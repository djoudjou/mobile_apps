import 'dart:async';

import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/domain/messages/i_messages_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

@injectable
class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final IMessagesRepository _messagesRepository;
  final IErrorService _errorService;
  StreamSubscription? _messagesSubscription;

  MessagesBloc(this._messagesRepository, this._errorService)
      : super(const MessagesState.initial());

  @override
  Stream<MessagesState> mapEventToState(MessagesEvent event) async* {
    yield* event.map(
      init: (Init e) async* {
        _messagesRepository.init();

        _messagesSubscription?.cancel();
        _messagesSubscription =
            _messagesRepository.getMessages().listen((state) {
              add(state.fold((l) => const MessagesEvent.onError(),
                      (r) => MessagesEvent.onMessage(r)));
            }, onError: (_) {
              _messagesSubscription?.cancel();
            });
      },
      saveToken: (SaveToken e) async* {
        try {
          final String userId = e.userId;

          final result = await _messagesRepository.saveToken(userId);

          yield result.fold((failure) {
            _errorService.logError("Unable to save token for user '$userId'");
            return state;
          }, (val) => MessagesState.tokenSaved(val));
        } catch (exception) {
          _errorService.logError(
              "Unable to save token for user ${e.userId} > $exception");
        }
      },
      onMessage: (OnMessage value) async* {
        yield MessagesState.messageReceived(value.message);
      },
      onError: (OnError value) async* {
        yield const MessagesState.errorReceived();
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
