import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/infrastructure/family/trusted_user_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trusted.freezed.dart';

@freezed
abstract class TrustedUser implements _$TrustedUser {
  const TrustedUser._(); // Added constructor

  const factory TrustedUser({
    required User user,
    required TimestampVo since,
  }) = _TrustedUser;

  TrustedUserEntity toEntity() {
    return TrustedUserEntity(
      id: user.id!,
      since: since.getOrCrash(),
    );
  }
}
