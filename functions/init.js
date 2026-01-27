'use strict';

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

const {
    onObjectFinalized
} = require('firebase-functions/v2/storage');

const { getFirestore, Timestamp, FieldValue, Filter } = require('firebase-admin/firestore');
// const {admin} = require('firebase-admin');

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

module.exports = {
    getFirestore,
    Timestamp,
    FieldValue,
    Filter,
    admin,
    db,
    genAI,
    apiKey,
    logger,
    onCall,
    onRequest,
    HttpsError,
    onInit,
    beforeUserCreated,
    beforeUserSignedIn,
    getMessaging,
    i18nPostalAddress,
    onDocumentWritten,
    onDocumentCreated,
    onDocumentUpdated,
    onDocumentDeleted,
    Change,
    FirestoreEvent,
    onObjectFinalized,
}