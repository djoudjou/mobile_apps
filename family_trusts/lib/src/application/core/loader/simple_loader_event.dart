import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_loader_event.freezed.dart';

@freezed
class SimpleLoaderEvent<T> with _$SimpleLoaderEvent {

  const factory SimpleLoaderEvent.startLoading({String? userId}) = StartLoading;

  const factory SimpleLoaderEvent.itemsUpdated(T events) = ItemsUpdated;
}
