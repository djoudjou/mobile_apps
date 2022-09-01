import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/family/family.dart';
import 'package:familytrusts/src/domain/join_proposal/value_objects.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_proposal.freezed.dart';

@freezed
class JoinProposal with _$JoinProposal {
  const JoinProposal._(); // Added constructor

  const factory JoinProposal({
    String? id,
    User? issuer,
    User? member,
    Family? family,
    JoinProposalStatus? state,
    required TimestampVo creationDate,
    required TimestampVo expirationDate,
    required TimestampVo lastUpdateDate,
  }) = _JoinProposal;
}
