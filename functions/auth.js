const {
    onCall,
    onRequest,
    HttpsError,
    admin,
    logger,
    getFirestore,
    Timestamp,
    beforeUserCreated,
    beforeUserSignedIn } = require("./init");
const { getCompanyById, getDatacenterById, getGpuClusterById, getUserById } = require("./common");


/**
 * A callable function to get the sign-in providers for a given email address.
 *
 * @param {object} data The data passed to the function.
 * @param {string} data.email The email address to look up.
 * @returns {Promise<{providers: string[]}>} A promise that resolves with a list
 * of provider IDs (e.g., 'password', 'google.com').
 */
exports.getProvidersForEmail = onCall(async (request) => {
    const email = request.data.email;
    if (!email) {
        logger.error("Function called without an email.", { structuredData: true });
        throw new HttpsError(
            "invalid-argument",
            "The function must be called with one argument 'email' containing the user's email address.",
        );
    }

    logger.info(`Fetching providers for email: ${email}`, { structuredData: true });

    try {
        const userRecord = await admin.auth().getUserByEmail(email);
        const providers = userRecord.providerData.map((info) => info.providerId);
        logger.info(`Providers for ${email}: ${providers.join(", ")}`);
        return { providers };
    } catch (error) {
        // 'auth/user-not-found' is a common error and means no providers exist.
        logger.info(`No user found for email: ${email}`, { structuredData: true });
        return { providers: [] };
    }
});


exports.saveUser = beforeUserCreated(async (event) => {
    const user = event.data;
    const db = getFirestore();
    const userRef = db.collection('users').doc(user.uid);
    logger.info(user);

    var company = null;
    var company_id = null;
    var type = (user.isAnonymous ?? false) ? 'anonymous' : 'public';
    var display_name = user.displayName ?? null;

    try {
        var invitation_qs = await db.collection('invitations').where('email', '==', user.email).get();
        if (invitation_qs.docs.length == 1) {
            var invitation = invitation_qs.docs[0].data();
            company_id = invitation.company_id;
            var company_qs = await db.collection('companies').doc(company_id).get();
            company = company_qs.data();
            display_name = invitation.display_name;
            type = "corporate_viewer";
            await invitation_qs.docs[0].ref.update({ status: 'accepted', uid: user.uid });
            await admin.auth().updateUser(user.uid, { displayName: display_name });
        }
    } catch (e) {
        logger.error(e);
    }

    await userRef.set({
        email: user.email ?? null,
        display_name: display_name,
        photo_url: user.photoURL ?? null,
        created_at: Timestamp.now(),
        uid: user.uid,
        email_verified: user.emailVerified ?? false,
        type: type,
        company: company,
        company_id: company_id,
        is_anonymous: user.isAnonymous ?? false,
    }, { merge: true });
});

exports.updateUser = beforeUserSignedIn(async (event) => {
    const user = event.data;
    const db = getFirestore();
    const userRef = db.collection('users').doc(user.uid);
    logger.info(user);
    await userRef.update({
        email_verified: user.emailVerified ?? false,
        last_login_at: Timestamp.now(),
        is_anonymous: user.isAnonymous ?? false,
    });
});

exports.updateUserToken = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }

    if (!request.data.fcmToken) {
        return { 'message': 'Invalid request: missing fcmToken' };
    }

    const uid = request.auth.uid; // Securely get UID from auth context
    const fcmToken = request.data.fcmToken;
    const action = request.data.action;
    const db = getFirestore();
    const userRef = db.doc(`users/${uid}`);

    const qs = await userRef.get();
    if (!qs.exists) {
        return { 'message': 'User not found' };
    }

    var fcmTokens = qs.data().fcm_tokens;
    if (!fcmTokens) {
        fcmTokens = [];
    }
    if (action == 'delete') {
        fcmTokens = fcmTokens.filter(token => token !== fcmToken);
    } else if (action == 'add') {
        if (!fcmTokens.includes(fcmToken)) {
            fcmTokens.push(fcmToken);
        }
    }
    await userRef.update({
        fcm_tokens: fcmTokens,
    });
    return { 'message': 'Success' };
});
