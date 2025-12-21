const { onDocumentUpdated, getFirestore } = require("./init");

const { getCompanyById, getDatacenterById, getGpuClusterById, getUserById } = require("./common");

exports.datacenterUpdate = onDocumentUpdated("datacenters/{datacenterId}", async (event) => {
    const db = getFirestore();
    const datacenterId = event.params.datacenterId;
    const afterData = event.data.after.data();
    const beforeData = event.data.before.data();

    if (afterData) {
        await db.runTransaction(async (t) => {
            const datacenterRef = db.doc(`datacenters/${datacenterId}`);
            const datacenterDoc = await datacenterRef.get();
            if (!datacenterDoc.exists) {
                return;
            }
            const datacenterData = datacenterDoc.data();

            const gpuClustersRef = db.collectionGroup(`gpu_clusters`).where('datacenter_id', '==', datacenterId);
            const gpuClustersSnapshot = await gpuClustersRef.get();
            gpuClustersSnapshot.forEach((gpuClusterDoc) => {
                t.update(gpuClusterDoc.ref, { datacenter: datacenterData });
            });
        });
    }
});