import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_event.dart';
import 'package:familytrusts/src/application/core/loader/simple_loader_state.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SimpleLoaderBloc<Type>
    extends Bloc<SimpleLoaderEvent, SimpleLoaderState> with LogMixin {
  SimpleLoaderBloc() : super(const SimpleLoaderState.simpleInitialState()) {
    on<StartLoading>(_mapStartLoading, transformer: sequential());
    on<ItemsUpdated>(_mapItemsUpdated, transformer: sequential());
  }

  Future<FutureOr<void>> _mapStartLoading(
    StartLoading event,
    Emitter<SimpleLoaderState> emit,
  ) async {
    emit(const SimpleLoaderState.simpleLoadingState());
    try {
      final Type data = await load(event);
      add(SimpleLoaderEvent.itemsUpdated(data));
    } catch (e) {
      log("Erreur technique > $e");
      emit(const SimpleLoaderState.simpleErrorEventState());
    }
  }

  FutureOr<void> _mapItemsUpdated(
    ItemsUpdated event,
    Emitter<SimpleLoaderState> emit,
  ) {
    emit(SimpleLoaderState.simpleSuccessEventState(event.events));
  }

  Future<Type> load(StartLoading event);
}
