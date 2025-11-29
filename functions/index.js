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
const { onCall, onRequest, HttpsError } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const { onInit } = require('firebase-functions/v2/core');
const { beforeUserCreated, beforeUserSignedIn } = require("firebase-functions/v2/identity");
const { getMessaging } = require("firebase-admin/messaging");

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
  await userRef.set({
    email: user.email ?? null,
    display_name: user.displayName ?? null,
    photo_url: user.photoURL ?? null,
    created_at: Timestamp.now(),
    uid: user.uid,
    email_verified: user.emailVerified,
    type: 'public'
  }, { merge: true });
});

exports.updateUser = beforeUserSignedIn(async (event) => {
  const user = event.data;
  const db = getFirestore();
  const userRef = db.collection('users').doc(user.uid);
  await userRef.update({
    email_verified: user.emailVerified,
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
    if (!clusterDoc.exists) return;

    let transactions = clusterDoc.data().transactions || [];

    // Remove existing entry for this transactionId
    transactions = transactions.filter(tx => tx.id !== transactionId);

    // If not a deletion, add the new data
    if (afterData) {
      transactions.push({ ...afterData, id: transactionId });
    }

    t.update(clusterRef, { transactions });
  });
});