const functions = require('firebase-functions');
const admin = require('firebase-admin');
const request = require('request-promise');
const events = require("events");
const async = require("async");

require('dotenv').config();

const serviceAccount = {
    type: process.env.TYPE,
    project_id: process.env.PROJECT_ID,
    private_key_id: process.env.PRIVATE_KEY_ID,
    private_key: process.env.PRIVATE_KEY,
    client_email: process.env.CLIENT_EMAIL,
    client_id: process.env.CLIENT_ID,
    auth_uri: process.env.AUTH_URI,
    token_uri: process.env.TOKEN_URI,
    auth_provider_x509_cert_url: process.env.AUTH_PROVIDER_X_CERT_URL,
    client_x509_cert_url: process.env.CLIENT_X_CERT_URL
}

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://sancheschat-3af9d.firebaseio.com"
})

const kakaoRequestMeUrl = 'https://kapi.kakao.com/v2/user/me?secure_resource=true';

exports.kakaoToken = functions
    .region('asia-northeast3').https.onCall((data, context) => {
        var access_token = data['accessToken'];
        var token = createFirebaseToken(access_token);
        return token;
    });

/**
 * requestMe - Returns user profile from Kakao API
 *
 * @param  {String} kakaoAccessToken Access token retrieved by Kakao Login API
 * @return {Promiise<Response>}      User profile response in a promise
 */
async function requestMe(kakaoAccessToken) {
    console.log('Requesting user profile from Kakao API server. ' + kakaoAccessToken);
    const result = await request({
        method: 'GET',
        headers: {'Authorization': 'Bearer ' + kakaoAccessToken},
        url: kakaoRequestMeUrl,
    })
    return result;
}

async function updateOrCreateUser(updateParams) {
    console.log('updating or creating a firebase user');
    console.log(updateParams);
    try {
        var userRecord = await admin.auth().getUserByEmail(updateParams['email']);
    } catch (error) {
        if (error.code === 'auth/user-not-found') {
            return admin.auth().createUser(updateParams);
        }
        throw error;
    }
    return userRecord;
}

/**
 * createFirebaseToken - returns Firebase token using Firebase Admin SDK
 *
 *    @param  {String} kakaoAccessToken Access token retrieved by Kakao Login API
 *  * @param  {String} userId        user id per app
 *  * @param  {String} email         user's email address
 *  * @param  {String} displayName   user
 *  * @param  {String} photoURL      profile photo url
 *  * @return {Prommise<UserRecord>} Firebase user record in a promise
 *  */

async function createFirebaseToken(kakaoAccessToken) {
    const requestMeResult = await requestMe(kakaoAccessToken);
    const userData = JSON.parse(requestMeResult)
    console.log(userData);

    const userId = `kakao:${userData.id}`;
    if (!userId) {
        return response.status(404).send({ message: 'There was no user with the given access token.' });
    }

    let nickname = null;
    let profileImage = null;
    if (userData.properties) {
        nickname = userData.properties.nickname;
        profileImage = userData.properties.profile_image;
    }

    const updateParams = {
        provider: 'KAKAO',
        displayName: nickname,
        email: userData.kakao_account.email,
    };

    if (nickname) {
        updateParams['displayName'] = nickname;
    } else {
        updateParams['displayName'] = userData.kakao_account.email;
    }
    if (profileImage) {
        updateParams['photoURL'] = profileImage;
    }

    console.log(updateParams);
    let user = await updateOrCreateUser(updateParams);
    return admin.auth().createCustomToken(user.uid, { provider: 'KAKAO' });
}

exports.sendNotifications =
    functions.region('asia-northeast3').firestore.document('/users/{sendId}/recentMessages/{receiveId}')
    .onWrite( (snapshot, context) => {
        const receiver = context.params.receiveId;
        const afterData = snapshot.after.data()
        const beforeData = snapshot.before.data()

        admin.auth().getUser()
        if (beforeData.text === afterData.text) {
            return new Promise((resolve) => resolve())
        }

        if (afterData.messageSource === 'from') {
            return new Promise((resolve) => resolve())
        }

        const sendNotification =
            admin.firestore().collection('fcmTokens').doc(receiver).get().then( async (doc) =>{
                const title = snapshot.after.get('toChatUser.name');
                const content = snapshot.after.get('text');
                const payload = {
                    notification: {
                        title: title,
                        body: content,
                    },
                    token: doc.get('value')
                };
                let response = await admin.messaging().send(payload);
                console.log(response)
        })
        return Promise.all(sendNotification)
    });
