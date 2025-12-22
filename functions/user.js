
const { onDocumentUpdated, getFirestore } = require("./init");

const { companyDocPath, userDocPath } = require("./common");


exports.userUpdate = onDocumentUpdated("users/{userId}", async (event) => {
    const db = getFirestore();
    const userId = event.params.userId;
    const afterData = event.data.after.data();
    const beforeData = event.data.before.data();

    if (afterData && afterData.company_id && afterData.company_id != beforeData.company_id) {
        await db.runTransaction(async (t) => {
            const companyRef = db.doc(companyDocPath(afterData.company_id));

            const companyDoc = await companyRef.get();
            if (!companyDoc.exists) {
                return;
            }
            const companyData = companyDoc.data();
            const userRef = db.doc(userDocPath(userId));
            t.update(userRef, { company: companyData });
        });
    }
});
