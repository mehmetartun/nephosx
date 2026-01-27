const { REQUESTS_COLLECTION } = require("./constants");
const { onCall, HttpsError, logger, Timestamp } = require("./init");

exports.addRequest = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }
    if (!request.data.data || !request.data.type) {
        logger.error({ message: 'One of the required arguments is missing', request: request });
        throw new HttpsError(
            "invalid-argument",
            "One of the required arguments is missing."
        )
    }
    const db = getFirestore();
    await db.runTransaction(async (t) => {
        const data = {
            ...request.data.data,
            type: request.data.type,
            status: 'pending',
            created_at: Timestamp.now(),
            request_date: Timestamp.now(),
            created_by: request.auth.uid
        }
        const docRef = await db.collection(REQUESTS_COLLECTION).add(data);
        if (request.data.company_id) {
            companyRef = await db.collection(COMPANIES_COLLECTION).doc(request.data.company_id).collection(REQUESTS_COLLECTION).add(data);
            t.update(companyRef, { id: companyRef.id, request_id: docRef.id });
        }
        t.update(docRef, { id: docRef.id });
    });
});