import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/domain/core/value_objects.dart';
import 'package:familytrusts/src/domain/invitation/i_spouse_proposal_repository.dart';
import 'package:familytrusts/src/domain/invitation/invitation.dart';
import 'package:familytrusts/src/domain/invitation/invitation_failure.dart';
import 'package:familytrusts/src/domain/invitation/value_objects.dart';
import 'package:familytrusts/src/domain/user/i_user_repository.dart';
import 'package:familytrusts/src/domain/user/user.dart';
import 'package:familytrusts/src/domain/user/user_failure.dart';
import 'package:familytrusts/src/infrastructure/core/firestore_helpers.dart';
import 'package:familytrusts/src/infrastructure/invitation/invitation_entity.dart';
import 'package:familytrusts/src/infrastructure/invitation/spouse_proposal_entity.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ISpouseProposalRepository)
class FirebaseSpouseProposalRepository extends ISpouseProposalRepository {
  final FirebaseFirestore _firebaseFirestore;
  final IUserRepository _userRepository;

  FirebaseSpouseProposalRepository(
    this._firebaseFirestore,
    this._userRepository,
  );

  @override
  Future<Either<InvitationFailure, Invitation?>> getSpouseProposal(
      String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>>snapshot =
          await _firebaseFirestore.userDocumentByUserId(userId).get();

      if (!snapshot.exists) {
        return right(null);
      }

      final SpouseProposalEntity spouseProposalEntity =
          SpouseProposalEntity.fromFirestore(snapshot);

      if (spouseProposalEntity.spouseProposal == null) {
        return right(null);
      }

      final InvitationEntity invitationEntity =
          InvitationEntity.fromJson(spouseProposalEntity.spouseProposal!);

      final Either<UserFailure, User> eitherTo =
          await _userRepository.getUser(invitationEntity.to);
      final Either<UserFailure, User> eitherFrom =
          await _userRepository.getUser(invitationEntity.from);

      if (eitherTo.isLeft()) {
        return left(InvitationFailure.unknownUser(invitationEntity.to));
      }
      if (eitherFrom.isLeft()) {
        return left(InvitationFailure.unknownUser(invitationEntity.from));
      }

      return right(
        Invitation(
          date: TimestampVo.fromTimestamp(invitationEntity.date),
          type: InvitationType.fromValue(invitationEntity.type),
          to: eitherTo.toOption().toNullable()!,
          from: eitherFrom.toOption().toNullable()!,
        ),
      );
    } on PlatformException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const InvitationFailure.insufficientPermission());
      } else {
        return left(const InvitationFailure.unexpected());
      }
    } on Exception {
      return left(const InvitationFailure.unexpected());
    }
  }

  @override
  Future<Either<InvitationFailure, Unit>> createSpouseProposal(
      User user, Invitation invitation) async {
    try {
      final SpouseProposalEntity spouseProposalEntity =
          SpouseProposalEntity.fromDomain(invitation);

      //log("debug > ${spouseProposalEntity.toJson()}");

      await _firebaseFirestore
          .userDocumentByUserId(user.id!)
          .update(spouseProposalEntity.toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const InvitationFailure.insufficientPermission());
      } else {
        return left(const InvitationFailure.unexpected());
      }
    } on Exception {
      return left(const InvitationFailure.unexpected());
    }
  }

  @override
  Future<Either<InvitationFailure, Unit>> deleteSpouseProposal(
      User user) async {
    try {
      await _firebaseFirestore
          .userDocumentByUserId(user.id!)
          .update(const SpouseProposalEntity().toJson());
      return right(unit);
    } on PlatformException catch (e) {
      if (e.message?.contains('PERMISSION_DENIED') ?? false) {
        return left(const InvitationFailure.insufficientPermission());
      } else {
        return left(const InvitationFailure.unexpected());
      }
    } on Exception {
      return left(const InvitationFailure.unexpected());
    }
  }
}
