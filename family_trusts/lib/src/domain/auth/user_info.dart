import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';

@freezed
class MyUserInfo with _$MyUserInfo {
  const MyUserInfo._(); // Added constructor

  const factory MyUserInfo({
    String? email,
    String? photoUrl,
    String? displayName,
  }) = _MyUserInfo;
}
