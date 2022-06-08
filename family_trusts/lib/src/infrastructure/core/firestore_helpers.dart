import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/core/errors.dart';

extension FirebaseFirestoreX on FirebaseFirestore {
  static const String usersCollectionName = "users";
  static const String spouseProposalsCollectionName = 'spouse_proposals';
  static const String notificationsCollectionName = "notifications";
  static const String familyCollectionName = "families";

  static const String childrenLookupsCollectionName = "children_lookups";
  static const String historiesCollectionName = "history";

  Future<DocumentReference<Map<String, dynamic>>> userDocument() async {
    final userOption = getIt<IAuthFacade>().getSignedInUserId();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return FirebaseFirestore.instance.collection(usersCollectionName).doc(user);
  }

  DocumentReference<Map<String, dynamic>> userDocumentByUserId(String userId) {
    return FirebaseFirestore.instance
        .collection(usersCollectionName)
        .doc(userId);
  }

  DocumentReference<Map<String, dynamic>> spouseProposalByUserId(
    String userId,
  ) {
    return FirebaseFirestore.instance
        .collection(spouseProposalsCollectionName)
        .doc(userId);
  }

  DocumentReference<Map<String, dynamic>> familyById(String familyId) {
    return FirebaseFirestore.instance
        .collection(familyCollectionName)
        .doc(familyId);
  }

  DocumentReference<Map<String, dynamic>> notificationsByUserId(String userId) {
    return FirebaseFirestore.instance
        .collection(notificationsCollectionName)
        .doc(userId);
  }

  CollectionReference<Map<String, dynamic>> childrenLookups() {
    return FirebaseFirestore.instance.collection(childrenLookupsCollectionName);
  }

  DocumentReference<Map<String, dynamic>> childrenLookup({
    required String childrenLookupId,
  }) {
    return childrenLookups().doc(childrenLookupId);
  }

  CollectionReference<Map<String, dynamic>> childrenLookupHistories({
    required String childrenLookupId,
  }) {
    return childrenLookups()
        .doc(childrenLookupId)
        .collection(historiesCollectionName);
  }

  DocumentReference<Map<String, dynamic>> childrenLookupHistory({
    required String childrenLookupId,
    required String childrenLookupHistoryId,
  }) {
    return childrenLookupHistories(childrenLookupId: childrenLookupId)
        .doc(childrenLookupHistoryId);
  }
}

extension DocumentReferenceX on DocumentReference {
  static const String invitationsCollectionName = "invitations";
  static const String eventsCollectionName = "events";

  static const String childrenCollectionName = "children";
  static const String trustedCollectionName = "trusted";
  static const String locationsCollectionName = "locations";

  CollectionReference<Map<String, dynamic>> get invitationsCollection =>
      collection(invitationsCollectionName);

  CollectionReference<Map<String, dynamic>> get eventsCollection =>
      collection(eventsCollectionName);

  CollectionReference<Map<String, dynamic>> get childrenCollection =>
      collection(childrenCollectionName);

  CollectionReference<Map<String, dynamic>> get trustedCollection =>
      collection(trustedCollectionName);

  CollectionReference<Map<String, dynamic>> get locationsCollection =>
      collection(locationsCollectionName);
}
