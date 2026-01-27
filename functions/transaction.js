const {
    getFirestore,
    Timestamp,
    onDocumentWritten,
    onCall,
    onRequest,
    HttpsError,
    FieldValue,
    logger, onObjectFinalized
} = require("./init");
const { getCompanyById, getDatacenterById, getGpuClusterById } = require("./common");

const { LISTINGS_COLLECTION, TRANSACTIONS_COLLECTION, GPU_CLUSTERS_COLLECTION } = require("./constants");
// exports.copyTransaction = onDocumentWritten("transactions/{transactionId}", async (event) => {
//     const db = getFirestore();
//     const transactionId = event.params.transactionId;
//     const afterData = event.data.after.data();
//     const beforeData = event.data.before.data();

//     // Determine gpu_cluster_id
//     const gpuClusterId = afterData ? afterData.gpu_cluster_id : beforeData.gpu_cluster_id;
//     if (!gpuClusterId) return; // Should not happen if data is valid

//     const clusterRef = db.doc(`datacenters/${afterData.datacenter_id}/gpu_clusters/${gpuClusterId}`);

//     await db.runTransaction(async (t) => {
//         const clusterDoc = await t.get(clusterRef);

//         var buyer_company_id = afterData.buyer_company_id;
//         var seller_company_id = afterData.seller_company_id;
//         var buyer_company_ref = await db.collection('companies').doc(buyer_company_id).get();
//         var seller_company_ref = await db.collection('companies').doc(seller_company_id).get();

//         const buyer_company_doc = await t.get(buyer_company_ref);
//         const seller_company_doc = await t.get(seller_company_ref);

//         const data = {
//             ...afterData,
//             buyer_company: buyer_company_doc.data(),
//             seller_company: seller_company_doc.data()
//         }

//         if (!clusterDoc.exists) return;

//         let transactions = clusterDoc.data().transactions || [];

//         // Remove existing entry for this transactionId
//         transactions = transactions.filter(tx => tx.id !== transactionId);

//         // If not a deletion, add the new data
//         if (afterData) {
//             transactions.push({ ...data, id: transactionId });
//         }

//         t.update(clusterRef, { transactions });
//     });
// });

exports.addTransaction = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "The function must be called while authenticated."
        );
    }
    if (
        !request.data.start_date ||
        !request.data.end_date ||
        !request.data.seller_company_id ||
        !request.data.buyer_company_id ||
        !request.data.gpu_cluster_id ||
        !request.data.consideration.amount ||
        !request.data.consideration.currency
    ) {
        logger.error({ message: 'One of the required arguments is missing', request: request });
        throw new HttpsError(
            "invalid-argument",
            "One of the required arguments is missing."
        );
    }

    const db = getFirestore();
    var transaction_id;

    await db.runTransaction(async (t) => {
        const sellerCompany = await getCompanyById(request.data.seller_company_id);
        const buyerCompany = await getCompanyById(request.data.buyer_company_id);
        const gpuCluster = await getGpuClusterById(request.data.gpu_cluster_id, request.data.datacenter_id);
        const datacenter = await getDatacenterById(request.data.datacenter_id);
        var txData = {
            start_date: Timestamp.fromMillis(request.data.start_date),
            end_date: Timestamp.fromMillis(request.data.end_date),
            seller_company_id: request.data.seller_company_id,
            buyer_company_id: request.data.buyer_company_id,
            counterparty_ids: [request.data.buyer_company_id, request.data.seller_company_id],
            gpu_cluster_id: request.data.gpu_cluster_id,
            consideration: request.data.consideration,
            created_at: Timestamp.now(),
            datacenter_id: datacenter.id,
            datacenter: datacenter,
            gpu_cluster: gpuCluster,
            seller_company: sellerCompany,
            buyer_company: buyerCompany,
        };
        var txref = await db.collection(TRANSACTIONS_COLLECTION).add(txData);
        var txBuyerRef = await db.collection(`companies/${request.data.buyer_company_id}/transactions`).add(txData);
        var txSellerRef = await db.collection(`companies/${request.data.seller_company_id}/transactions`).add(txData);

        if (request.data.listing_id) {
            var listing_qs = await db.collection(LISTINGS_COLLECTION).doc(request.data.listing_id).get();
            t.update(listing_qs.ref, { transaction_id: txref.id, status: 'traded' });
        }
        t.update(txref, {
            id: txref.id,
            buyer_transaction_reference: txBuyerRef,
            seller_transaction_reference: txSellerRef
        });
        t.update(txBuyerRef, { id: txBuyerRef.id, transaction_reference: txref, transaction_id: txref.id });
        t.update(txSellerRef, { id: txSellerRef.id, transaction_reference: txref, transaction_id: txref.id });
        transaction_id = txref.id;
    });
    return { 'message': 'Transaction added successfully', transaction_id: transaction_id };
});


// exports.tempTransactionUpdate = onRequest(
//     async (req, res) => {
//         const db = getFirestore();
//         const qs = db.collection('transactions').get();

//         var futs = [];
//         (await qs).forEach((doc) => {
//             futs.push(doc.ref.update(
//                 {
//                     counterparty_ids:
//                         [doc.data()['buyer_company_id'], doc.data()['seller_company_id']]
//                 }));
//         })
//         await Promise.all(futs);
//         res.send({ 'message': 'Transaction data updated successfully' });
//     }
// );

// exports.cleanUpTransactionDataOnGpuClusters = onRequest(async (req, res) => {
//     const db = getFirestore();
//     var gpus = await db.collectionGroup('gpu_clusters').get();
//     gpus.forEach((doc) => {
//         doc.ref.update({ transactions: [] });
//     });
//     res.send({ 'message': 'Transaction data cleaned up successfully' });
// });

exports.updateTransactionOnUpload = onObjectFinalized(async (event) => {
    const fileBucket = event.data.bucket;
    const filePath = event.data.name;
    const contentType = event.data.contentType;

    if (!filePath.startsWith("transactions/")) {
        return logger.log("Not a transaction file.");
    }

    const parts = filePath.split("/");
    if (parts.length < 3) {
        return logger.log("File path is not deep enough to be a transaction file.");
    }
    const transactionId = parts[1];
    const fileName = parts.pop();

    const db = getFirestore();
    const transactionRef = db.collection(TRANSACTIONS_COLLECTION).doc(transactionId);

    const fileData = {
        path: filePath,
        bucket: fileBucket,
        name: fileName,
        content_type: contentType,
        url: event.data.mediaLink || `https://storage.googleapis.com/${fileBucket}/${filePath}`,
        created_at: Timestamp.now(),
    };

    try {
        await transactionRef.update({
            documents: FieldValue.arrayUnion(fileData)
        });
        logger.log(`Updated transaction ${transactionId} with document ${fileName}`);
    } catch (error) {
        logger.error(`Error updating transaction ${transactionId}:`, error);
    }
});



