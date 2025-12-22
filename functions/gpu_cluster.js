
const { onDocumentWritten, getFirestore, onCall, HttpsError, logger } = require("./init");


const { getCompanyById, getDatacenterById, getGpuClusterById, getUserById, datacenterDocPath, gpuClusterDocPath, companyDocPath } = require("./common");
const { DATACENTERS_COLLECTION, GPU_CLUSTERS_COLLECTION, COMPANIES_COLLECTION } = require("./constants");

exports.gpuClusterWritten = onDocumentWritten(`${DATACENTERS_COLLECTION}/{datacenterId}/${GPU_CLUSTERS_COLLECTION}/{gpuClusterId}`, async (event) => {
    const db = getFirestore();
    const gpuClusterId = event.params.gpuClusterId;
    const datacenterId = event.params.datacenterId;
    const afterData = event.data.after.data();
    const beforeData = event.data.before.data();

    if (afterData && (!afterData.datacenter || !afterData.company)) {
        await db.runTransaction(async (t) => {
            const companyRef = db.doc(companyDocPath(afterData.company_id));
            const companyDoc = await companyRef.get();
            if (!companyDoc.exists) {
                return;
            }
            const companyData = companyDoc.data();
            const datacenterRef = db.doc(datacenterDocPath(datacenterId));
            const datacenterDoc = await datacenterRef.get();
            if (!datacenterDoc.exists) {
                return;
            }
            const datacenterData = datacenterDoc.data();
            const gpuClusterRef = db.doc(gpuClusterDocPath(gpuClusterId, datacenterId));
            t.update(gpuClusterRef, { company: companyData, datacenter: datacenterData });
        });
    }
});

exports.gpuClusterUpdateCheck = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }
    console.log(request.data);
    if (
        !request.data.gpuClusterId
    ) {
        logger.error({ message: 'One of the required arguments is missing', request: request });
        throw new HttpsError(
            "invalid-argument",
            "One of the required arguments is missing."
        );
    }

    const db = getFirestore();

    var futs = [];
    var listing_qs;
    var transaction_qs;
    futs.push(db.collection('listings').where('gpu_cluster_id', '==', request.data.gpuClusterId).get().then(
        (querySnapshot) => {
            listing_qs = querySnapshot;
        }
    ));
    futs.push(db.collection('transactions').where('gpu_cluster_id', '==', request.data.gpuClusterId).get().then(
        (querySnapshot) => {
            transaction_qs = querySnapshot;
        }
    ));
    await Promise.all(futs);
    if (listing_qs.docs.length == 0 && transaction_qs.docs.length == 0) {
        return { 'update_possible': true };
    } else {
        return { 'update_possible': false };
    }
});

