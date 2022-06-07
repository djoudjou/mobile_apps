import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


export const eventsNotSeenCount = functions
    .region('europe-west1')
    .firestore
    .document('notifications/{userId}/events/{eventId}')
    .onWrite(async (change, context) => {

        const userNotificationsRef = db.collection('notifications').doc(context.params.userId);
        const eventsNotReadRef = userNotificationsRef.collection('events').where('seen', "==", false);

        return db.runTransaction(transaction => {
            return transaction.get(eventsNotReadRef).then(eventsQuery => {
              const unReadCount = eventsQuery.size;
                console.log(`userId:${context.params.userId} count ${unReadCount}`);
              return transaction.set(userNotificationsRef, {
                unReadCount: unReadCount
              });
            });
          });
    });

export const sendToDevice = functions
    .region('europe-west1')
    .firestore
    .document('children_lookups/{lookupID}/history/{historyID}')
    .onCreate(async (snapshot, context) => {

        const history = snapshot.data();

        const trustedUsers = await getTrustedUsers(context.params.lookupID);

        console.log(`getTrustedUsers result #${trustedUsers}#`);

        const tokens: string[] = [];
        for (const userId of trustedUsers) {
            if(userId !== history.subjectId) {
                const result = await getTokens(userId);
                console.log(`getTokens result #${result}#`);
                tokens.push(... result);
            }
        }
        
        console.log(`console from typescript ${tokens}`);

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'Récupérer enfants',
                body: history.message,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        return fcm.sendToDevice(tokens, payload);
    });


async function getTrustedUsers(lookupId: string) {
    try {
        console.log(`getTrustedUsers #${lookupId}#`);
        const snapshot = await admin.firestore().collection('children_lookups').doc(lookupId).get();
        if (snapshot.exists) {
            return snapshot.data()?.trustedUsers;
        } else {
            console.log(`No lookup with id: ${lookupId}`);
        }
    } catch (error) {
        // I would suggest you throw an error
        console.log('Error getting Lookup Information:', error);
        return `NOT FOUND: ${error}`;
    }
}

async function getTokens(userId: string) {
    try {
        console.log(`getTokens #${userId}#`);
        const querySnapshot = await db
            .collection('users')
            .doc(userId)
            .collection('tokens')
            .get();

        return querySnapshot.docs.map(snap => snap.id);
    } catch (error) {
        // I would suggest you throw an error
        console.log('Error getting tokens Information:', error);
        return ``;
    }
}

