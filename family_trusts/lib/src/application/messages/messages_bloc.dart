import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrusts/src/application/messages/bloc.dart';
import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/domain/messages/i_messages_repository.dart';
import 'package:familytrusts/src/domain/messages/messages_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  static const Duration duration = Duration(milliseconds: 500);
  final IMessagesRepository _messagesRepository;
  final IErrorService _errorService;
  StreamSubscription? _messagesSubscription;

  MessagesBloc(
    this._messagesRepository,
    this._errorService,
  ) : super(const MessagesState.initial()) {
    on<Init>(_mapInit, transformer: sequential());
    on<SaveToken>(_mapSaveToken, transformer: sequential());
    on<OnMessage>(_mapOnMessage, transformer: sequential());
    on<OnError>(_mapOnError, transformer: sequential());
  }

  Future<FutureOr<void>> _mapInit(
    Init event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      final Either<MessagesFailure, Unit> resultInit =
          await _messagesRepository.init();

      if (resultInit.isLeft()) {
        add(const MessagesEvent.onError());
      }

      _messagesSubscription?.cancel();
      _messagesSubscription = _messagesRepository.getMessages().listen(
        (state) {
          add(
            state.fold(
              (l) => const MessagesEvent.onError(),
              (r) => MessagesEvent.onMessage(r),
            ),
          );
        },
        onError: (_) {
          _messagesSubscription?.cancel();
        },
      );
    } catch (exception) {
      _errorService.logError(
        "Unable to Init messages repository > $exception",
      );
    }
  }

  Future<FutureOr<void>> _mapSaveToken(
    SaveToken event,
    Emitter<MessagesState> emit,
  ) async {
    try {
      final String userId = event.userId;

      final result = await _messagesRepository.saveToken(userId);

      emit(
        result.fold(
          (failure) {
            _errorService.logError("Unable to save token for user '$userId'");
            return state;
          },
          (val) => MessagesState.tokenSaved(val),
        ),
      );
    } catch (exception) {
      _errorService.logError(
        "Unable to save token for user ${event.userId} > $exception",
      );
    }
  }

  FutureOr<void> _mapOnMessage(OnMessage event, Emitter<MessagesState> emit) {
    emit(MessagesState.messageReceived(event.message));
  }

  FutureOr<void> _mapOnError(OnError event, Emitter<MessagesState> emit) {
    emit(const MessagesState.errorReceived());
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _messagesRepository.close();
    return super.close();
  }
}
