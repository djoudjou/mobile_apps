import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted_user_entity.freezed.dart';

part 'trusted_user_entity.g.dart';

@freezed
class TrustedUserEntity with _$TrustedUserEntity {
  const TrustedUserEntity._(); // Added constructor

  const factory TrustedUserEntity({
    required String id,
    required int since,
  }) = _TrustedUserEntity;

  factory TrustedUserEntity.fromJson(Map<String, dynamic> json) =>
      _$TrustedUserEntityFromJson(json);

  factory TrustedUserEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return TrustedUserEntity.fromJson(doc.data()!).copyWith(id: doc.id);
  }
}
