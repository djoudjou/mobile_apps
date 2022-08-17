import 'dart:async';

import 'package:familytrusts/src/application/messages/bloc.dart';
import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/domain/messages/i_messages_repository.dart';
import 'package:familytrusts/src/helper/bloc_helper.dart';
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
    on<MessagesEvent>(
      (event, emit) => mapEventToState(event, emit),
      transformer: debounce(duration),
    );
  }

  void mapEventToState(
    MessagesEvent event,
    Emitter<MessagesState> emit,
  ) {
    event.map(
      init: (Init e) {
        _messagesRepository.init();

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
      },
      saveToken: (SaveToken e) async {
        try {
          final String userId = e.userId;

          final result = await _messagesRepository.saveToken(userId);

          emit(
            result.fold(
              (failure) {
                _errorService
                    .logError("Unable to save token for user '$userId'");
                return state;
              },
              (val) => MessagesState.tokenSaved(val),
            ),
          );
        } catch (exception) {
          _errorService.logError(
            "Unable to save token for user ${e.userId} > $exception",
          );
        }
      },
      onMessage: (OnMessage value) {
        emit(MessagesState.messageReceived(value.message));
      },
      onError: (OnError value) {
        emit(const MessagesState.errorReceived());
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _messagesRepository.close();
    return super.close();
  }
}
