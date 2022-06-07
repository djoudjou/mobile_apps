import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

extension StorageReferenceX on firebase_storage.Reference {
  firebase_storage.Reference userPhotoStorage(String userId) {
    return firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users")
        .child(userId);
  }

  firebase_storage.Reference childrenPhotoStorage(String childId) {
    return firebase_storage.FirebaseStorage.instance
        .ref()
        .child("children")
        .child(childId);
  }

  firebase_storage.Reference locationPhotoStorage(
      String familyId, String locationId) {
    return firebase_storage.FirebaseStorage.instance
        .ref()
        .child("locations")
        .child(familyId)
        .child(locationId);
  }
}
