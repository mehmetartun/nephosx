'use strict';

const { getFirestore, HttpsError, logger } = require("./init");

async function getUserById(userId) {
    const db = getFirestore();
    var user = await db.collection('users').doc(userId).get();
    if (!user.exists) {
        logger.error({ message: 'User not found', userId: userId });
        throw new HttpsError('user-not-found', 'User not found');
    }
    return user.data();
};



async function getCompanyById(companyId) {
    const db = getFirestore();
    var company = await db.collection('companies').doc(companyId).get();
    if (!company.exists) {
        logger.error({ message: 'Company not found', companyId: companyId });
        throw new HttpsError('company-not-found', 'Company not found');
    }
    return company.data();
}

async function getGpuClusterById(gpuClusterId, datacenterId) {
    console.log(gpuClusterId, datacenterId);
    const db = getFirestore();
    var gpuCluster = await db.collection('datacenters').doc(datacenterId).collection('gpu_clusters').doc(gpuClusterId).get();
    if (!gpuCluster.exists) {
        logger.error({ message: 'GPU Cluster not found', gpuClusterId: gpuClusterId });
        throw new HttpsError('gpu-cluster-not-found', 'GPU Cluster not found');
    }
    return { ...gpuCluster.data(), company: null, datacenter: null, rental_prices: null };
}

async function getDatacenterById(datacenterId) {
    const db = getFirestore();
    var datacenter = await db.collection('datacenters').doc(datacenterId).get();
    if (!datacenter.exists) {
        logger.error({ message: 'Datacenter not found', datacenterId: datacenterId });
        throw new HttpsError('datacenter-not-found', 'Datacenter not found');
    }
    return datacenter.data();
}


module.exports = {
    getUserById,
    getCompanyById,
    getGpuClusterById,
    getDatacenterById,
}

