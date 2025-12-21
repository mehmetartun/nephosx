const { onCall, HttpsError, getFirestore, Timestamp } = require("./init");
const { getCompanyById, getDatacenterById, getGpuClusterById, getUserById } = require("./common");

exports.addListing = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }
    console.log(request.data);
    if (
        !request.data.start_date
        || !request.data.end_date
        || !request.data.company_id
        || !request.data.datacenter_id
        || !request.data.gpu_cluster_id
        || !request.data.rental_prices
        || !request.data.status
    ) {
        logger.error({ message: 'One of the required arguments is missing', request: request });
        throw new HttpsError(
            "invalid-argument",
            "One of the required arguments is missing."
        );
    }

    const db = getFirestore();

    await db.runTransaction(async (t) => {
        const company = await getCompanyById(request.data.company_id);
        const datacenter = await getDatacenterById(request.data.datacenter_id);
        const gpuCluster = await getGpuClusterById(request.data.gpu_cluster_id, request.data.datacenter_id);
        var txref = await db.collection('listings').add({
            start_date: Timestamp.fromMillis(request.data.start_date),
            end_date: Timestamp.fromMillis(request.data.end_date),
            company_id: request.data.company_id,
            datacenter_id: request.data.datacenter_id,
            gpu_cluster_id: request.data.gpu_cluster_id,
            created_at: Timestamp.now(),
            datacenter: datacenter,
            gpu_cluster: gpuCluster,
            company: company,
            status: request.data.status,
            rental_prices: request.data.rental_prices
        });
        t.update(txref, { id: txref.id });
    });
    return { 'message': 'Listing added successfully' };
});

