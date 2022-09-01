import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/join_proposal/family_join_proposal_event.dart';
import 'package:familytrusts/src/application/join_proposal/family_join_proposal_state.dart';
import 'package:familytrusts/src/domain/join_proposal/i_join_proposal_repository.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class FamilyJoinProposalBloc
    extends Bloc<FamilyJoinProposalEvent, FamilyJoinProposalState> {
  final IJoinProposalRepository _joinProposalRepository;

  FamilyJoinProposalBloc(
    this._joinProposalRepository,
  ) : super(const FamilyJoinProposalState.initial()) {
    on<FamilyLoadProposals>(_mapLoadProposals, transformer: sequential());
    on<Accept>(_mapAccept, transformer: sequential());
    on<Decline>(_mapDecline, transformer: sequential());
  }

  FutureOr<void> _mapDecline(
    Decline event,
    Emitter<FamilyJoinProposalState> emit,
  ) async {
    emit(const FamilyJoinProposalState.joinProposalDeclineInProgress());

    final Either<JoinProposalFailure, Unit> resultDeclineProposal =
        await _joinProposalRepository.declineProposal(
      event.connectedUser,
      event.joinProposal.id!,
    );

    emit(
      resultDeclineProposal.fold(
        (failure) {
          // TODO ADJ handle specific error message
          return const FamilyJoinProposalState.joinProposalDeclineFailure("");
        },
        (success) => const FamilyJoinProposalState.joinProposalDeclineSuccess(),
      ),
    );
  }

  FutureOr<void> _mapAccept(
    Accept event,
    Emitter<FamilyJoinProposalState> emit,
  ) async {
    emit(const FamilyJoinProposalState.joinProposalAcceptInProgress());

    final Either<JoinProposalFailure, Unit> resultAcceptProposal =
        await _joinProposalRepository.acceptProposal(
      event.connectedUser,
      event.joinProposal.id!,
    );

    emit(
      resultAcceptProposal.fold(
        (failure) {
          // TODO ADJ handle specific error message
          return const FamilyJoinProposalState.joinProposalAcceptFailure("");
        },
        (success) => const FamilyJoinProposalState.joinProposalAcceptSuccess(),
      ),
    );
  }

  FutureOr<void> _mapLoadProposals(
    FamilyLoadProposals event,
    Emitter<FamilyJoinProposalState> emit,
  ) async {
    if(event.family != null) {
      emit(const FamilyJoinProposalState.joinProposalsLoadInProgress());

      final Either<JoinProposalFailure, List<JoinProposal>>
      resultFindPendingProposals = await _joinProposalRepository
          .findPendingProposalsByFamily(event.family!);

      emit(
        resultFindPendingProposals.fold(
              (failure) =>
          const FamilyJoinProposalState.joinProposalsLoadFailure(""),
              (pendingProposals) =>
              FamilyJoinProposalState.joinProposalsLoaded(
                hasPendingProposals: true,
                pendingProposals: pendingProposals,
              ),
        ),
      );
    }
  }
}
