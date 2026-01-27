
const { onDocumentWritten, getFirestore, onCall, HttpsError, logger, Timestamp } = require("./init");


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

exports.addGpuCluster = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }
    if (
        !request.data.device_id ||
        !request.data.cpu_id ||
        !request.data.quantity ||
        !request.data.datacenter_id ||
        !request.data.company_id ||
        !request.data.start_date ||
        !request.data.end_date ||
        !request.data.serial_number ||
        !request.data.asset_tag ||
        !request.data.manufacture_date
    ) {
        logger.error({ message: 'One of the required arguments is missing', request: request });
        throw new HttpsError(
            "invalid-argument",
            "One of the required arguments is missing."
        );
    }
    const db = getFirestore();
    try {
        await db.runTransaction(async (t) => {
            const company = await getCompanyById(request.data.company_id);
            const datacenter = await getDatacenterById(request.data.datacenter_id);
            var data = {
                datacenter_id: request.data.datacenter_id,
                company_id: request.data.company_id,
                device_id: request.data.device_id,
                cpu_id: request.data.cpu_id,
                quantity: request.data.quantity,
                start_date: Timestamp.fromMillis(request.data.start_date),
                end_date: Timestamp.fromMillis(request.data.end_date),
                manufacture_date: Timestamp.fromMillis(request.data.manufacture_date),
                created_at: Timestamp.now(),
                serial_number: request.data.serial_number,
                asset_tag: request.data.asset_tag,
                company: company,
                datacenter: datacenter,
                per_gpu_vram_in_gb: request.data.per_gpu_vram_in_gb ??= null,
                per_gpu_memory_bandwidth_in_gb_per_sec: request.data.per_gpu_memory_bandwidth_in_gb_per_sec ??= null,
                per_gpu_nv_link_bandwidth_in_gb_per_sec: request.data.per_gpu_nv_link_bandwidth_in_gb_per_sec ??= null,
                tera_flops: request.data.tera_flops ??= null,
                pcie_generation: request.data.pcie_generation ??= null,
                pcie_lanes: request.data.pcie_lanes ??= null,
                per_gpu_pcie_bandwidth_in_gb_per_sec: request.data.per_gpu_pcie_bandwidth_in_gb_per_sec ??= null,
                maximum_cuda_version_supported: request.data.maximum_cuda_version_supported ??= null,
                effective_ram: request.data.effective_ram ??= null,
                total_ram: request.data.total_ram ??= null,
                total_cpu_core_count: request.data.total_cpu_core_count ??= null,
                effective_cpu_core_count: request.data.effective_cpu_core_count ??= null,
                internet_upload_speed_in_mbps: request.data.internet_upload_speed_in_mbps ??= null,
                internet_download_speed_in_mbps: request.data.internet_download_speed_in_mbps ??= null,
                number_of_open_ports: request.data.number_of_open_ports ??= null,
                disk_bandwidth_in_mb_per_sec: request.data.disk_bandwidth_in_mb_per_sec ??= null,
                disk_storage_available_in_gb: request.data.disk_storage_available_in_gb ??= null,
                deep_learning_performance_score: request.data.deep_learning_performance_score ??= null,
            };
            var gpuClusterRef = await db.collection(DATACENTERS_COLLECTION).doc(request.data.datacenter_id).collection(GPU_CLUSTERS_COLLECTION).add(data);
            await t.update(gpuClusterRef, { id: gpuClusterRef.id });
        })

    } catch (e) {
        logger.error({ message: 'Failed to add gpu cluster', request: request, error: e });
        throw new HttpsError(
            "internal",
            "Failed to add gpu cluster."
        );
    }


});

