import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_proposal_failure.freezed.dart';

@freezed
class JoinProposalFailure with _$JoinProposalFailure {
  const factory JoinProposalFailure.insufficientPermission() = InsufficientPermission;
  const factory JoinProposalFailure.serverError() = ServerError;
  const factory JoinProposalFailure.unknown(String? joinProposalId) = Unknown;

}
