const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('chat/{message}')
  .onCreate((snapshot, context) => {

    const message = {
        notification: {
            title: snapshot.data().username,
            body: snapshot.data().text,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
    };

    return admin.messaging().sendToTopic('chat',message);
  });