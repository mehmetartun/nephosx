// exports.getRecipeNew = onCall({
//   secrets: ['GOOGLE_API_KEY'],
//   timeoutSeconds: 540,
// }, async (request) => {
//   const schema = request.data.schema;
//   const languageModel = request.data.languageModel;


//   try {
//     // Get the model, specifying the JSON output mode
//     const model = genAI.getGenerativeModel({
//       model: languageModel, // Use a model that supports JSON mode
//       generationConfig: {
//         responseMimeType: 'application/json',
//         responseSchema: schema,
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
//     // const prompt = 'Give me a great recipe for classic buttermilk pancakes.';

//     const prompt = request.data.prompt;

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
//     // res.status(200).json(recipeJson);
//     return recipeJson;
//   } catch (error) {
//     console.error('Error calling Gemini API:', error);
//     if (error.response) {
//       console.error('API Response Data:', error.response.data);
//     }
//     res.status(500).send(`Error processing request: ${error.message}.`);
//     return { 'error': error.message };
//   }
// });

/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */




// exports.updateLog = onDocumentUpdated("drinks/{drinkId}", async (event) => {
//   await db.collection("update_logs").add({
//     'before': event.data.before.data(),
//     'document_path': event.data.before.ref.path,
//     'after': event.data.after.data(),
//     'timestamp': admin.firestore.FieldValue.serverTimestamp()
//   });

// });

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", { structuredData: true });
//   response.send("Hello from Firebase!");
// });

// exports.hello = onCall((request) => {
//   return "Hello World";
// });




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






















