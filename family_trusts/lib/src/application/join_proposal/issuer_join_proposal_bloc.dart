import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/join_proposal/bloc.dart';
import 'package:familytrusts/src/domain/join_proposal/i_join_proposal_repository.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal.dart';
import 'package:familytrusts/src/domain/join_proposal/join_proposal_failure.dart';
import 'package:familytrusts/src/domain/join_proposal/value_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class IssuerJoinProposalBloc extends Bloc<IssuerJoinProposalEvent, IssuerJoinProposalState> {
  final IJoinProposalRepository _joinProposalRepository;

  IssuerJoinProposalBloc(
    this._joinProposalRepository,
  ) : super(const IssuerJoinProposalState.initial()) {
    on<Send>(_mapSend, transformer: sequential());
    on<Cancel>(_mapCancel, transformer: sequential());
    on<LoadProposals>(_mapLoadProposals, transformer: sequential());
  }

  FutureOr<void> _mapSend(Send event, Emitter<IssuerJoinProposalState> emit) async {
    emit(const IssuerJoinProposalState.joinProposalSendInProgress());

    final Either<JoinProposalFailure, Unit> resultSendProposal =
        await _joinProposalRepository.sendProposal(
      event.connectedUser,
      event.family,
    );

    emit(
      resultSendProposal.fold(
        (failure) {
          // TODO ADJ handle specific error message
          return const IssuerJoinProposalState.joinProposalSendFailure("");
        },
        (success) => const IssuerJoinProposalState.joinProposalSendSuccess(),
      ),
    );
  }

  FutureOr<void> _mapCancel(
    Cancel event,
    Emitter<IssuerJoinProposalState> emit,
  ) async {
    emit(const IssuerJoinProposalState.joinProposalCancelInProgress());

    final Either<JoinProposalFailure, Unit> resultCancelProposal =
        await _joinProposalRepository.cancelProposal(
      event.connectedUser,
      event.joinProposal.id!,
    );

    emit(
      resultCancelProposal.fold(
        (failure) {
          // TODO ADJ handle specific error message
          return const IssuerJoinProposalState.joinProposalCancelFailure("");
        },
        (success) => const IssuerJoinProposalState.joinProposalCancelSuccess(),
      ),
    );
  }

  FutureOr<void> _mapLoadProposals(
    LoadProposals event,
    Emitter<IssuerJoinProposalState> emit,
  ) async {
    emit(const IssuerJoinProposalState.joinProposalsLoadInProgress());

    final Either<JoinProposalFailure, List<JoinProposal>>
        resultFindArchivedProposals =
        await _joinProposalRepository.findArchivedByUser(
      event.connectedUser,
    );

    final Either<JoinProposalFailure, Option<JoinProposal>>
        resultFindPendingProposal =
        await _joinProposalRepository.findPendingByUser(
      event.connectedUser,
    );

    if (resultFindPendingProposal.isLeft() ||
        resultFindArchivedProposals.isLeft()) {
      // TODO ADJ handle specific error message
      emit(const IssuerJoinProposalState.joinProposalsLoadFailure(""));
    } else {
      final Option<JoinProposal> pendingJoinProposal =
          resultFindPendingProposal.getOrElse(() => none());
      final List<JoinProposal> archivedJoinProposals =
          resultFindArchivedProposals.getOrElse(() => List.empty());

      emit(
        IssuerJoinProposalState.joinProposalsLoaded(
          hasPendingProposals: pendingJoinProposal.isSome(),
          archives: archivedJoinProposals,
          optionPendingJoinProposal: pendingJoinProposal,
        ),
      );
    }
  }

  bool isWaiting(JoinProposal jp) {
    return jp.state!.isValid() &&
        jp.state!.getOrCrash() == JoinProposalStateEnum.waiting;
  }
}
