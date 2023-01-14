import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:connectivity/connectivity.dart';
import 'package:familytrusts/src/application/connection/connection_event.dart';
import 'package:familytrusts/src/application/connection/connection_state.dart';
import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConnectBloc extends Bloc<ConnectEvent, ConnectState> {
  static const Duration duration = Duration(milliseconds: 500);
  final IErrorService _errorService;
  StreamSubscription? _streamSubscription;

  ConnectBloc(
    this._errorService,
  ) : super(const ConnectState.initial()) {
    on<Init>(_mapInit, transformer: sequential());
    on<Disconnect>(_mapDisconnect, transformer: sequential());
    on<Connect>(_mapConnect, transformer: sequential());
  }

  Future<FutureOr<void>> _mapInit(
    Init event,
    Emitter<ConnectState> emit,
  ) async {
    try {
      _streamSubscription = Connectivity().onConnectivityChanged.listen(
        (connectivityResult) {
          if (connectivityResult == ConnectivityResult.none) {
            add(const ConnectEvent.disconnect());
          } else {
            add(const ConnectEvent.connect());
          }
        },
      );
    } catch (exception) {
      _errorService.logError(
        "Unable to Init ConnectionBloc > $exception",
      );
    }
  }

  FutureOr<void> _mapDisconnect(
    Disconnect event,
    Emitter<ConnectState> emit,
  ) async {
    try {
      final ConnectivityResult result =
          await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.none) {
        emit(const ConnectState.disconnected());
      } else {
        emit(const ConnectState.connected());
      }
    } catch (exception) {
      _errorService.logError(
        "Unable to _mapDisconnect in ConnectionBloc > $exception",
      );
    }
  }

  FutureOr<void> _mapConnect(
      Connect event,
      Emitter<ConnectState> emit,
      ) async {
    try {
      final ConnectivityResult result =
      await Connectivity().checkConnectivity();

      if (result == ConnectivityResult.none) {
        emit(const ConnectState.disconnected());
      } else {
        emit(const ConnectState.connected());
      }
    } catch (exception) {
      _errorService.logError(
        "Unable to _mapConnect in ConnectionBloc > $exception",
      );
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
