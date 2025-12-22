const { onDocumentUpdated, getFirestore, onCall, HttpsError, Timestamp } = require("./init");

const { companyDocPath, requestDocPath } = require("./common");
const { USERS_COLLECTION, INVITATIONS_COLLECTION, GPU_CLUSTERS_COLLECTION, REQUESTS_COLLECTION, COMPANIES_COLLECTION } = require("./constants");

exports.companyUpdate = onDocumentUpdated(`${COMPANIES_COLLECTION}/{companyId}`, async (event) => {
    const db = getFirestore();
    const companyId = event.params.companyId;
    const afterData = event.data.after.data();
    const beforeData = event.data.before.data();

    if (afterData) {
        await db.runTransaction(async (t) => {
            const companyRef = db.doc(companyDocPath(companyId));
            const companyDoc = await companyRef.get();
            if (!companyDoc.exists) {
                return;
            }
            const companyData = companyDoc.data();
            const usersRef = db.collection(USERS_COLLECTION).where('company_id', '==', companyId);
            const usersSnapshot = await usersRef.get();
            usersSnapshot.forEach((userDoc) => {
                t.update(userDoc.ref, { company: companyData });
            });
            const gpuClustersRef = db.collectionGroup(GPU_CLUSTERS_COLLECTION).where('company_id', '==', companyId);
            const gpuClustersSnapshot = await gpuClustersRef.get();
            gpuClustersSnapshot.forEach((gpuClusterDoc) => {
                t.update(gpuClusterDoc.ref, { company: companyData });
            });
        });
    }
});


exports.corpAdminAddInvitation = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }
    if (!request.data.email || !request.data.displayName || !request.data.companyId || !request.data.companyName) {
        throw new HttpsError(
            "invalid-argument",
            "The function must be called with one argument 'email', 'displayName', 'companyId', 'companyName', 'message' containing the company's name, domain, confirmation email, user ID, and user type."
        );
    }

    const db = getFirestore();

    var qs = await db.collection(INVITATIONS_COLLECTION).where('email', '==', request.data.email).get();
    if (qs.docs.length > 0) {
        throw new HttpsError(
            "invalid-argument",
            "The invitation already exists."
        );
    }

    await db.runTransaction(async (t) => {
        var docref = await db.collection(INVITATIONS_COLLECTION).add({
            inviting_user_id: request.auth.uid,
            email: request.data.email,
            display_name: request.data.displayName,
            company_id: request.data.companyId,
            company_name: request.data.companyName,
            created_at: Timestamp.now(),
            status: 'invited',
        });

        var msg = `Dear ${request.data.displayName}, you have been invited to join ${request.data.companyName} on the NephosX platform. <a href="https://nephosx-dev.web.app/corporate_user_accept?id=${docref.id}">Join NephosX</a> now.`;
        var emailref = await db.collection('mail').add({
            to: request.data.email,
            message: {
                subject: 'Invitation to join ' + request.data.companyName,
                html: msg,
                text: `You have been invited to join ${request.data.companyName} on the NephosX platform. Copy and paste this link in your browser: https://nephosx-dev.web.app/corporate_user_accept?id=${docref.id}.`,
            }
        })
        t.update(docref, { id: docref.id, mail_record_id: emailref.id, message: msg });
    });
    return { 'message': 'Invitation added successfully' };
});


exports.adminAddCompany = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }
    if (!request.data.companyName || !request.data.companyDomain || !request.data.confirmationEmail || !request.data.userId || !request.data.userType || !request.data.requestId) {
        throw new HttpsError(
            "invalid-argument",
            "The function must be called with one argument 'companyName', 'companyDomain', 'confirmationEmail', 'userId', 'userType' containing the company's name, domain, confirmation email, user ID, and user type."
        );
    }

    const db = getFirestore();

    var qs = await db.collection(COMPANIES_COLLECTION).where('domain', '==', request.data.companyDomain).get();
    if (qs.docs.length > 0) {
        throw new HttpsError(
            "invalid-argument",
            "The company domain already exists."
        );
    }

    await db.runTransaction(async (t) => {
        const companyRef = await db.collection(COMPANIES_COLLECTION).add({
            name: request.data.companyName,
            domain: request.data.companyDomain,
            created_at: Timestamp.now(),
            confirmation_email: request.data.confirmationEmail,
        });


        const requestPath = requestDocPath(request.data.requestId);
        const userPath = userDocPath(request.data.userId);
        const userDoc = await db.doc(userPath).get();
        if (!userDoc.exists) {
            throw new HttpsError(
                "invalid-argument",
                "The user does not exist."
            );
        }
        t.update(companyRef, { id: companyRef.id });
        t.update(userDoc.ref, { company_id: companyRef.id, type: request.data.userType });
        t.update(db.doc(requestPath), { status: 'accepted' });
    });
    return { 'message': 'Company added successfully', 'id': companyRef.id };
});




