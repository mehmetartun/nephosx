'use strict';

const { getFirestore, HttpsError, logger } = require("./init");

const {
    USERS_COLLECTION,
    COMPANIES_COLLECTION,
    DATACENTERS_COLLECTION,
    GPU_CLUSTERS_COLLECTION,
    TRANSACTIONS_COLLECTION,
    LISTINGS_COLLECTION
} = require("./constants");

async function getUserById(userId) {
    const db = getFirestore();
    var user = await db.doc(userDocPath(userId)).get();
    if (!user.exists) {
        logger.error({ message: 'User not found', userId: userId });
        throw new HttpsError('user-not-found', 'User not found');
    }
    return user.data();
};



async function getCompanyById(companyId) {
    const db = getFirestore();
    var company = await db.doc(companyDocPath(companyId)).get();
    if (!company.exists) {
        logger.error({ message: 'Company not found', companyId: companyId });
        throw new HttpsError('company-not-found', 'Company not found');
    }
    return company.data();
}

async function getGpuClusterById(gpuClusterId, datacenterId) {
    console.log(gpuClusterId, datacenterId);
    const db = getFirestore();
    var gpuCluster = await db.doc(gpuClusterDocPath(gpuClusterId, datacenterId)).get();
    if (!gpuCluster.exists) {
        logger.error({ message: 'GPU Cluster not found', gpuClusterId: gpuClusterId });
        throw new HttpsError('gpu-cluster-not-found', 'GPU Cluster not found');
    }
    return { ...gpuCluster.data(), company: null, datacenter: null, rental_prices: null };
}

async function getDatacenterById(datacenterId) {
    const db = getFirestore();
    var datacenter = await db.doc(datacenterDocPath(datacenterId)).get();
    if (!datacenter.exists) {
        logger.error({ message: 'Datacenter not found', datacenterId: datacenterId });
        throw new HttpsError('datacenter-not-found', 'Datacenter not found');
    }
    return datacenter.data();
}

function userDocPath(uid) {
    return `${USERS_COLLECTION}/${uid}`;
}

function companyDocPath(companyId) {
    return `${COMPANIES_COLLECTION}/${companyId}`;
}

function gpuClusterDocPath(gpuClusterId, datacenterId) {
    return `${DATACENTERS_COLLECTION}/${datacenterId}/${GPU_CLUSTERS_COLLECTION}/${gpuClusterId}`;
}

function datacenterDocPath(datacenterId) {
    return `${DATACENTERS_COLLECTION}/${datacenterId}`;
}

function transactionDocPath(transactionId) {
    return `${TRANSACTIONS_COLLECTION}/${transactionId}`;
}

function listingDocPath(listingId) {
    return `${LISTINGS_COLLECTION}/${listingId}`;
}

function requestDocPath(requestId) {
    return `${REQUESTS_COLLECTION}/${requestId}`;
}

module.exports = {
    getUserById,
    getCompanyById,
    getGpuClusterById,
    getDatacenterById,
    userDocPath,
    companyDocPath,
    gpuClusterDocPath,
    datacenterDocPath,
    transactionDocPath,
    listingDocPath
}

