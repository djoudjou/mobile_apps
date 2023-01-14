import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_event.freezed.dart';

@freezed
class ConnectEvent with _$ConnectEvent {
  const factory ConnectEvent.init() = Init;

  const factory ConnectEvent.disconnect() = Disconnect;
  const factory ConnectEvent.connect() = Connect;
}
