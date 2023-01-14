import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state.freezed.dart';

@freezed
class ConnectState with _$ConnectState {
  const factory ConnectState.initial() = Initial;

  const factory ConnectState.disconnected() = Disconnected;

  const factory ConnectState.connected() = Connected;
}
