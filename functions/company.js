const { onDocumentUpdated, getFirestore, onCall, HttpsError, Timestamp } = require("./init");

const { companyDocPath, requestDocPath, userDocPath } = require("./common");
const {
    USERS_COLLECTION,
    INVITATIONS_COLLECTION,
    GPU_CLUSTERS_COLLECTION,
    REQUESTS_COLLECTION,
    COMPANIES_COLLECTION,
    MAIL_COLLECTION
} = require("./constants");

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
        var docRef = db.collection(INVITATIONS_COLLECTION).doc();
        var emailRef = db.collection(MAIL_COLLECTION).doc();
        var msg = `Dear ${request.data.displayName}, you have been invited to join ${request.data.companyName} on the NephosX platform. <a href="https://nephosx-dev.web.app/corporate_user_accept?id=${docRef.id}">Join NephosX</a> now.`;

        t.set(emailRef, {
            to: request.data.email,
            message: {
                subject: 'Invitation to join ' + request.data.companyName,
                html: msg,
                text: `You have been invited to join ${request.data.companyName} on the NephosX platform. Copy and paste this link in your browser: https://nephosx-dev.web.app/corporate_user_accept?id=${docRef.id}.`,
            }
        });
        t.set(docRef, {
            id: docRef.id,
            inviting_user_id: request.auth.uid,
            email: request.data.email,
            display_name: request.data.displayName,
            company_id: request.data.companyId,
            company_name: request.data.companyName,
            created_at: Timestamp.now(),
            status: 'invited',
            mail_record_id: emailRef.id,
            message: msg
        });
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

    var companyRef;
    var docRef = db.collection(REQUESTS_COLLECTION).doc(request.data.requestId);

    await db.runTransaction(async (t) => {
        companyRef = db.collection(COMPANIES_COLLECTION).doc();
        const userPath = userDocPath(request.data.userId);
        const userDoc = await db.doc(userPath).get();

        if (!userDoc.exists) {
            throw new HttpsError(
                "invalid-argument",
                "The user does not exist."
            );
        }
        await companyRef.set({
            id: companyRef.id,
            name: request.data.companyName,
            domain: request.data.companyDomain,
            created_at: Timestamp.now(),
            confirmation_email: request.data.confirmationEmail,
        });


        const requestPath = requestDocPath(request.data.requestId);


        // t.update(companyRef, { id: companyRef.id });
        t.set(companyRef, {
            id: companyRef.id,
            name: request.data.companyName,
            domain: request.data.companyDomain,
            created_at: Timestamp.now(),
            confirmation_email: request.data.confirmationEmail,
        });
        t.update(userDoc.ref, { company_id: companyRef.id, type: request.data.userType });
        t.update(db.doc(requestPath), { status: 'accepted' });
    });
    return { 'message': 'Company added successfully', 'id': companyRef.id };
});

exports.setPrimaryContactForCompany = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }
    if (!request.data.companyId || !request.data.userId) {
        throw new HttpsError(
            "invalid-argument",
            "The function must be called with one argument 'companyId', 'userId' containing the company's ID and user ID."
        );
    }

    const db = getFirestore();

    var companyRef = db.collection(COMPANIES_COLLECTION).doc(request.data.companyId);
    var userRef = db.collection(USERS_COLLECTION).doc(request.data.userId);

    await db.runTransaction(async (t) => {
        const companyDoc = await companyRef.get();
        const userDoc = await userRef.get();

        if (!companyDoc.exists) {
            throw new HttpsError(
                "invalid-argument",
                "The company does not exist."
            );
        }
        if (!userDoc.exists) {
            throw new HttpsError(
                "invalid-argument",
                "The user does not exist."
            );
        }
        t.update(companyRef,
            {
                primary_contact_id: request.data.userId,
                primary_contact: userDoc.data()
            });
        // t.update(userRef, { company_id: request.data.companyId });
    });
    return { 'message': 'Primary contact set successfully' };
});


