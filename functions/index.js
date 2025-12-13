/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const admin = require("firebase-admin");
const { setGlobalOptions } = require("firebase-functions");
const { defineSecret } = require('firebase-functions/params');
const { onCall, onRequest, HttpsError, } = require("firebase-functions/v2/https");
const { logger } = require("firebase-functions");
const { onInit } = require('firebase-functions/v2/core');
const { beforeUserCreated, beforeUserSignedIn } = require("firebase-functions/v2/identity");
const { getMessaging } = require("firebase-admin/messaging");

const { i18nPostalAddress } = require('i18n-postal-address');

const {
  onDocumentWritten,
  onDocumentCreated,
  onDocumentUpdated,
  onDocumentDeleted,
  Change,
  FirestoreEvent
} = require('firebase-functions/v2/firestore');

const { getFirestore, Timestamp, FieldValue, Filter } = require('firebase-admin/firestore');

const {
  GoogleGenerativeAI,
  HarmCategory,
  HarmBlockThreshold,
} = require('@google/generative-ai');

// Get the API key from the environment variable
// const API_KEY = process.env.GEMINI_API_KEY;
const apiKey = defineSecret('GOOGLE_API_KEY');

// Initialize the Generative AI client
let genAI;
onInit(() => {
  genAI = new GoogleGenerativeAI(apiKey.value());
})

// Initialize the Firebase Admin SDK
admin.initializeApp();
const db = getFirestore();

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started


exports.updateLog = onDocumentUpdated("drinks/{drinkId}", async (event) => {
  await db.collection("update_logs").add({
    'before': event.data.before.data(),
    'document_path': event.data.before.ref.path,
    'after': event.data.after.data(),
    'timestamp': admin.firestore.FieldValue.serverTimestamp()
  });

});

exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});

exports.hello = onCall((request) => {
  return "Hello World";
});

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


const recipeSchema = {
  type: 'OBJECT',
  properties: {
    recipe_name: { type: 'STRING' },
    description: { type: 'STRING' },
    prep_time: { type: 'STRING' },
    cook_time: { type: 'STRING' },
    total_time: { type: 'STRING' },
    servings: { type: 'NUMBER' },
    ingredients: {
      type: 'ARRAY',
      items: {
        type: 'OBJECT',
        properties: {
          name: { type: 'STRING' },
          quantity: { type: 'STRING' },
        },
      },
    },
    instructions: {
      type: 'ARRAY',
      items: {
        type: 'OBJECT',
        properties: {
          step: { type: 'NUMBER' },
          description: { type: 'STRING' },
        },
      },
    },
  },
  required: ['recipe_name', 'ingredients', 'instructions', 'servings'],
};

// exports.getRecipe = onRequest( {
//   secrets: ['GOOGLE_API_KEY'],
// },async (req, res) => {


//   try {
//     // Get the model, specifying the JSON output mode
//     const model = genAI.getGenerativeModel({
//       model: 'gemini-2.5-flash', // Use a model that supports JSON mode
//       generationConfig: {
//         responseMimeType: 'application/json',
//         responseSchema: recipeSchema,
//       },
//     });

//     // Set safety settings
//     const safetySettings = [
//       {
//         category: HarmCategory.HARM_CATEGORY_HARASSMENT,
//         threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
//       },
//       {
//         category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
//         threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
//       },
//       // ... add other categories as needed
//     ];

//     // The prompt for the model
//     // Note: We don't have to say "in JSON" here because
//     // the responseMimeType and schema handle it for us.
//     const prompt = 'Give me a great recipe for classic buttermilk pancakes.';

//     // Send the prompt to the model
//     const result = await model.generateContent({
//       contents: [{ role: 'user', parts: [{ text: prompt }] }],
//       safetySettings,
//     });

//     const response = result.response;

//     // Check for a valid response
//     if (!response || !response.candidates || !response.candidates[0].content) {
//       throw new Error('Invalid response from Gemini API.');
//     }

//     // The model's response text will be a JSON string.
//     const jsonString = response.candidates[0].content.parts[0].text;

//     // Parse the JSON string into an object
//     const recipeJson = JSON.parse(jsonString);

//     // Send the structured JSON object as the HTTP response
//     res.status(200).json(recipeJson);
//   } catch (error) {
//     console.error('Error calling Gemini API:', error);
//     if (error.response) {
//       console.error('API Response Data:', error.response.data);
//     }
//     res.status(500).send(`Error processing request: ${error.message}.`);
//   }
// });


exports.getRecipeNew = onCall({
  secrets: ['GOOGLE_API_KEY'],
  timeoutSeconds: 540,
}, async (request) => {
  const schema = request.data.schema;
  const languageModel = request.data.languageModel;


  try {
    // Get the model, specifying the JSON output mode
    const model = genAI.getGenerativeModel({
      model: languageModel, // Use a model that supports JSON mode
      generationConfig: {
        responseMimeType: 'application/json',
        responseSchema: schema,
      },
    });

    // Set safety settings
    const safetySettings = [
      {
        category: HarmCategory.HARM_CATEGORY_HARASSMENT,
        threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
      },
      {
        category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
        threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
      },
      // ... add other categories as needed
    ];

    // The prompt for the model
    // Note: We don't have to say "in JSON" here because
    // the responseMimeType and schema handle it for us.
    // const prompt = 'Give me a great recipe for classic buttermilk pancakes.';

    const prompt = request.data.prompt;

    // Send the prompt to the model
    const result = await model.generateContent({
      contents: [{ role: 'user', parts: [{ text: prompt }] }],
      safetySettings,
    });

    const response = result.response;

    // Check for a valid response
    if (!response || !response.candidates || !response.candidates[0].content) {
      throw new Error('Invalid response from Gemini API.');
    }

    // The model's response text will be a JSON string.
    const jsonString = response.candidates[0].content.parts[0].text;

    // Parse the JSON string into an object
    const recipeJson = JSON.parse(jsonString);

    // Send the structured JSON object as the HTTP response
    // res.status(200).json(recipeJson);
    return recipeJson;
  } catch (error) {
    console.error('Error calling Gemini API:', error);
    if (error.response) {
      console.error('API Response Data:', error.response.data);
    }
    res.status(500).send(`Error processing request: ${error.message}.`);
    return { 'error': error.message };
  }
});


exports.saveUser = beforeUserCreated(async (event) => {
  const user = event.data;
  const db = getFirestore();
  const userRef = db.collection('users').doc(user.uid);
  logger.info(user);
  await userRef.set({
    email: user.email ?? null,
    display_name: user.displayName ?? null,
    photo_url: user.photoURL ?? null,
    created_at: Timestamp.now(),
    uid: user.uid,
    email_verified: user.emailVerified ?? false,
    type: (user.isAnonymous ?? false) ? 'anonymous' : 'public',
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

exports.companyUpdate = onDocumentUpdated("companies/{companyId}", async (event) => {
  const db = getFirestore();
  const companyId = event.params.companyId;
  const afterData = event.data.after.data();
  const beforeData = event.data.before.data();

  if (afterData) {
    await db.runTransaction(async (t) => {
      const companyRef = db.doc(`companies/${companyId}`);
      const companyDoc = await companyRef.get();
      if (!companyDoc.exists) {
        return;
      }
      const companyData = companyDoc.data();
      const usersRef = db.collection(`users`).where('company_id', '==', companyId);
      const usersSnapshot = await usersRef.get();
      usersSnapshot.forEach((userDoc) => {
        t.update(userDoc.ref, { company: companyData });
      });
      const gpuClustersRef = db.collectionGroup(`gpu_clusters`).where('company_id', '==', companyId);
      const gpuClustersSnapshot = await gpuClustersRef.get();
      gpuClustersSnapshot.forEach((gpuClusterDoc) => {
        t.update(gpuClusterDoc.ref, { company: companyData });
      });
    });
  }
});

exports.userUpdate = onDocumentUpdated("users/{userId}", async (event) => {
  const db = getFirestore();
  const userId = event.params.userId;
  const afterData = event.data.after.data();
  const beforeData = event.data.before.data();

  if (afterData && afterData.company_id && afterData.company_id != beforeData.company_id) {
    await db.runTransaction(async (t) => {
      const companyRef = db.doc(`companies/${afterData.company_id}`);
      const companyDoc = await companyRef.get();
      if (!companyDoc.exists) {
        return;
      }
      const companyData = companyDoc.data();
      const userRef = db.doc(`users/${userId}`);
      t.update(userRef, { company: companyData });
    });
  }
  // const userRef = db.doc(`users/${userId}`);
  // await userRef.update({
  //   email: afterData.email,
  //   display_name: afterData.display_name,
  //   photo_url: afterData.photo_url,
  //   email_verified: afterData.email_verified,
  //   type: afterData.type,
  // });
});


exports.gpuClusterWritten = onDocumentWritten("datacenters/{datacenterId}/gpu_clusters/{gpuClusterId}", async (event) => {
  const db = getFirestore();
  const gpuClusterId = event.params.gpuClusterId;
  const datacenterId = event.params.datacenterId;
  const afterData = event.data.after.data();
  const beforeData = event.data.before.data();

  if (afterData && (!afterData.datacenter || !afterData.company)) {
    await db.runTransaction(async (t) => {
      const companyRef = db.doc(`companies/${afterData.company_id}`);
      const companyDoc = await companyRef.get();
      if (!companyDoc.exists) {
        return;
      }
      const companyData = companyDoc.data();
      const datacenterRef = db.doc(`datacenters/${datacenterId}`);
      const datacenterDoc = await datacenterRef.get();
      if (!datacenterDoc.exists) {
        return;
      }
      const datacenterData = datacenterDoc.data();
      const gpuClusterRef = db.doc(`datacenters/${datacenterId}/gpu_clusters/${gpuClusterId}`);
      t.update(gpuClusterRef, { company: companyData, datacenter: datacenterData });
    });
  }
});

exports.copyTransaction = onDocumentWritten("transactions/{transactionId}", async (event) => {
  const db = getFirestore();
  const transactionId = event.params.transactionId;
  const afterData = event.data.after.data();
  const beforeData = event.data.before.data();

  // Determine gpu_cluster_id
  const gpuClusterId = afterData ? afterData.gpu_cluster_id : beforeData.gpu_cluster_id;
  if (!gpuClusterId) return; // Should not happen if data is valid

  const clusterRef = db.doc(`datacenters/${afterData.datacenter_id}/gpu_clusters/${gpuClusterId}`);

  await db.runTransaction(async (t) => {
    const clusterDoc = await t.get(clusterRef);

    var buyer_company_id = afterData.buyer_company_id;
    var seller_company_id = afterData.seller_company_id;
    var buyer_company_ref = await db.collection('companies').doc(buyer_company_id).get();
    var seller_company_ref = await db.collection('companies').doc(seller_company_id).get();

    const buyer_company_doc = await t.get(buyer_company_ref);
    const seller_company_doc = await t.get(seller_company_ref);

    const data = {
      ...afterData,
      buyer_company: buyer_company_doc.data(),
      seller_company: seller_company_doc.data()
    }

    if (!clusterDoc.exists) return;

    let transactions = clusterDoc.data().transactions || [];

    // Remove existing entry for this transactionId
    transactions = transactions.filter(tx => tx.id !== transactionId);

    // If not a deletion, add the new data
    if (afterData) {
      transactions.push({ ...data, id: transactionId });
    }

    t.update(clusterRef, { transactions });
  });
});

exports.addressWritten = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }
  if (!request.data.address) {
    return { 'message': 'Invalid request: missing address' };
  }
  var postal = new PostalAddress();
  postal.setAddress1(request.data.address.addressLine1);
  postal.setAddress2(request.data.address.addressLine2);
  postal.setCity(request.data.address.city);
  postal.setState(request.data.address.state);
  postal.setCountry(request.data.address.country);
  postal.setPostalCode(request.data.address.zipCode);
  postal.setFormat({ country: 'SE', type: 'personal' });
  var result = postal.format();
  console.log(result);
  return result;
});

exports.adminAddCompany = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }
  if (!request.data.companyName || !request.data.companyDomain || !request.data.confirmationEmail || !request.data.userId || !request.data.userType || !request.data.requestId) {
    throw new HttpsError(
      "invalid-argument",
      "The function must be called with one argument 'companyName', 'companyDomain', 'confirmationEmail', 'userId', 'userType' containing the company's name, domain, confirmation email, user ID, and user type."
    );
  }

  const db = getFirestore();

  var qs = await db.collection('companies').where('domain', '==', request.data.companyDomain).get();
  if (qs.docs.length > 0) {
    throw new HttpsError(
      "invalid-argument",
      "The company domain already exists."
    );
  }

  await db.runTransaction(async (t) => {
    const companyRef = await db.collection('companies').add({
      name: request.data.companyName,
      domain: request.data.companyDomain,
      created_at: Timestamp.now(),
      confirmation_email: request.data.confirmationEmail,
    });


    const requestPath = `requests/${request.data.requestId}`;
    const userPath = 'users/' + request.data.userId;
    const userDoc = await db.doc(userPath).get();
    if (!userDoc.exists) {
      throw new HttpsError(
        "invalid-argument",
        "The user does not exist."
      );
    }
    t.update(companyRef, { id: companyRef.id });
    t.update(userDoc.ref, { company_id: companyRef.id, type: request.data.userType });
    t.update(db.doc(requestPath), { status: 'accepted' });
  });
  return { 'message': 'Company added successfully', 'id': companyRef.id };
});

exports.corpAdminAddInvitation = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }
  if (!request.data.email || !request.data.displayName || !request.data.companyId || !request.data.companyName || !request.data.message) {
    throw new HttpsError(
      "invalid-argument",
      "The function must be called with one argument 'email', 'displayName', 'companyId', 'companyName', 'message' containing the company's name, domain, confirmation email, user ID, and user type."
    );
  }

  const db = getFirestore();

  var qs = await db.collection('invitations').where('email', '==', request.data.email).get();
  if (qs.docs.length > 0) {
    throw new HttpsError(
      "invalid-argument",
      "The invitation already exists."
    );
  }

  await db.runTransaction(async (t) => {
    var docref = await db.collection('invitations').add({
      inviting_user_id: request.auth.uid,
      email: request.data.email,
      display_name: request.data.displayName,
      company_id: request.data.companyId,
      company_name: request.data.companyName,
      message: request.data.message,
      created_at: Timestamp.now(),
      status: 'invited',
    });
    var emailref = await db.collection('mail').add({
      to: request.data.email,
      message: {
        subject: 'Invitation to join ' + request.data.companyName,
        html: request.data.message,
        text: 'Invitation to join ' + request.data.companyName,
      }
    })
    t.update(docref, { id: docref.id, mail_record_id: emailref.id });
  });
  return { 'message': 'Invitation added successfully' };
});

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

  await db.runTransaction(async (t) => {
    const sellerCompany = await getCompanyById(request.data.seller_company_id);
    const buyerCompany = await getCompanyById(request.data.buyer_company_id);
    const gpuCluster = await getGpuClusterById(request.data.gpu_cluster_id, request.data.datacenter_id);
    const datacenter = await getDatacenterById(request.data.datacenter_id);
    var txref = await db.collection('transactions').add({
      start_date: Timestamp.fromMillis(request.data.start_date),
      end_date: Timestamp.fromMillis(request.data.end_date),
      seller_company_id: request.data.seller_company_id,
      buyer_company_id: request.data.buyer_company_id,
      gpu_cluster_id: request.data.gpu_cluster_id,
      consideration: request.data.consideration,
      created_at: Timestamp.now(),
      datacenter_id: datacenter.id,
      datacenter: datacenter,
      gpu_cluster: gpuCluster,
      seller_company: sellerCompany,
      buyer_company: buyerCompany,
    });
    t.update(txref, { id: txref.id });
  });
  return { 'message': 'Transaction added successfully' };
});

exports.testFunc = onCall(async (request) => {
  return { 'message': 'Hello World' };
});

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

exports.cleanUpTransactionDataOnGpuClusters = onRequest(async (req, res) => {
  const db = getFirestore();
  var gpus = await db.collectionGroup('gpu_clusters').get();
  gpus.forEach((doc) => {
    doc.ref.update({ transactions: [] });
  });
  res.send({ 'message': 'Transaction data cleaned up successfully' });
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