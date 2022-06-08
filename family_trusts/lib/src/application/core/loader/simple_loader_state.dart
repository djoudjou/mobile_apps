import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_loader_state.freezed.dart';

@freezed
class SimpleLoaderState<T> with _$SimpleLoaderState {

  const factory SimpleLoaderState.simpleInitialState() = SimpleInitialState;

  const factory SimpleLoaderState.simpleLoadingState() = SimpleLoadingState;

  const factory SimpleLoaderState.simpleSuccessEventState(T items) = SimpleSuccessEventState;

  const factory SimpleLoaderState.simpleErrorEventState() = SimpleErrorEventState;
}
