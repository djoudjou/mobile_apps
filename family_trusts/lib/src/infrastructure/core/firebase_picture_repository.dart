import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/picture/picture_failure.dart';
import 'package:familytrusts/src/helper/firebase_helper.dart';
import 'package:familytrusts/src/infrastructure/core/storage_reference_helpers.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:quiver/strings.dart' as quiver;

@Environment(Environment.prod)
class FirebasePictureRepository with FirebaseHelper {
  final firebase_storage.Reference _storageReference;

  FirebasePictureRepository(
    this._storageReference,
  );

  Future<Either<PictureFailure, Option<String>>> saveChildPhoto({
    required String childId,
    String? pickedFilePath,
  }) {
    final firebase_storage.Reference ref =
        _storageReference.childrenPhotoStorage(childId);
    return tryUpload(pickedFilePath, ref);
  }

  Future<Either<PictureFailure, Option<String>>> saveLocationPhoto({
    required String familyId,
    required String locationId,
    String? pickedFilePath,
  }) {
    final firebase_storage.Reference ref =
        _storageReference.locationPhotoStorage(familyId, locationId);
    return tryUpload(pickedFilePath, ref);
  }

  Future<Either<PictureFailure, Option<String>>> saveUserPhoto({
    required String userId,
    String? pickedFilePath,
  }) {
    final firebase_storage.Reference ref =
        _storageReference.userPhotoStorage(userId);
    return tryUpload(pickedFilePath, ref);
  }

  Future<Either<PictureFailure, Option<String>>> tryUpload(
    String? pickedFilePath,
    firebase_storage.Reference ref,
  ) async {
    try {
      if (quiver.isNotBlank(pickedFilePath)) {
        final String downloadUrl = await addImage(File(pickedFilePath!), ref);

        return right(some(downloadUrl));
      }

      return right(none());
    } on PlatformException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const PictureFailure.insufficientPermission());
      } else {
        return left(const PictureFailure.unexpected());
      }
    } on Exception {
      return left(const PictureFailure.unexpected());
    }
  }
}
