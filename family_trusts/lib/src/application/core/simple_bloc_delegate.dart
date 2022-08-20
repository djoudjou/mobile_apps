import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocDelegate extends BlocObserver with LogMixin {
  @override
  void onEvent(Bloc bloc, Object? event) {
    log("#${bloc.runtimeType}# onEvent #$event#");
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log("#${bloc.runtimeType}# onError #$error#");
    //Analytics.sendEvent(error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log("#${bloc.runtimeType}# onTransition current <#${transition.currentState}#> event #${transition.event}# next state #${transition.nextState}#");
    //Analytics.sendEvent(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log("#${bloc.runtimeType}# onChange current state #${change.currentState}# next state #${change.nextState}#");
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    log("onClose bloc #${bloc.runtimeType}#");
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    log("onCreate bloc #${bloc.runtimeType}#");
    super.onCreate(bloc);
  }
}
