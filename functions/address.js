// const { onCall } = require("firebase-functions/v2/https");
// const { HttpsError } = require("firebase-functions/v2/https");
// const { logger } = require("firebase-functions");
// const { PostalAddress } = require('i18n-postal-address');

const { onCall, HttpsError, logger, i18nPostalAddress, PostalAddress } = require("./init");
const { getCompanyById, getDatacenterById, getGpuClusterById, getUserById } = require("./common");


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
    logger.info(result);
    return result;
});