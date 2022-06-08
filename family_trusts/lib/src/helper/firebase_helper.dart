import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class FirebaseHelper {
  static Future<String> addImage(
    File file,
    firebase_storage.Reference ref,
  ) async {
    final firebase_storage.UploadTask uploadTask = ref.putFile(file);

    // Storage tasks function as a Delegating Future so we can await them.
    final firebase_storage.TaskSnapshot snapshot = await uploadTask;

    return snapshot.ref.getDownloadURL();
  }

  static Future<void> deleteImageByUrl(String imageFileUrl) async {
    final fileUrl = Uri.decodeFull(path.basename(imageFileUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');
    final firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }
}
