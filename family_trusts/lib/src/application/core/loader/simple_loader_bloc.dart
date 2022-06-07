import 'dart:async';

import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_state.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SimpleLoaderBloc<Type>
    extends Bloc<SimpleLoaderEvent, SimpleLoaderState> with LogMixin {
  StreamSubscription? _itemsSubscription;

  SimpleLoaderBloc() : super(const SimpleLoaderState.simpleInitialState());

  @override
  Stream<SimpleLoaderState> mapEventToState(
    SimpleLoaderEvent event,
  ) async* {
    yield* event.map(
      startLoading: (startLoading) async* {
        yield const SimpleLoaderState.simpleLoadingState();
        try {
          _itemsSubscription?.cancel();
          _itemsSubscription = load(startLoading).listen(
            (data) {
              add(SimpleLoaderEvent.itemsUpdated(data));
            },
            onError: (_) => _itemsSubscription?.cancel(),
          );
        } catch (e) {
          log("Erreur technique > $e");
          yield const SimpleLoaderState.simpleErrorEventState();
        }
      },
      itemsUpdated: (itemsUpdated) async* {
        yield SimpleLoaderState.simpleSuccessEventState(itemsUpdated.events);
      },
    );
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }

  Stream<Type> load(StartLoading event);
}
