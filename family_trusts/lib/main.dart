import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:familytrusts/generated/codegen_loader.g.dart';
import 'package:familytrusts/injection.dart';
import 'package:familytrusts/src/application/core/simple_bloc_delegate.dart';
import 'package:familytrusts/src/domain/auth/i_auth_facade.dart';
import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/infrastructure/core/api_keys.dart';
import 'package:familytrusts/src/infrastructure/http/api_service.dart';
import 'package:familytrusts/src/presentation/core/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  _setupLogging();

  configureInjection(Environment.prod);

  getIt.registerSingleton(await ApiService.init(getIt<IAuthFacade>()));

  getIt.allReady();

  FlutterError.onError = (details, {bool forceReport = false}) {
    getIt<IErrorService>()
        .logException(details.exception, stackTrace: details.stack);
  };

  runZonedGuarded<Future<void>>(
    () async {
      await SentryFlutter.init(
        (options) {
          options.dsn = ApiKeys.sentryKey;
        },
      );
      BlocOverrides.runZoned(
        () => runApp(
          EasyLocalization(
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('fr', 'FR'),
            ],
            path: 'resources/langs',
            fallbackLocale: const Locale('en', 'US'),
            startLocale: const Locale('fr', 'FR'),
            assetLoader: const CodegenLoader(),
            child: AppWidget(),
          ),
        ),
        blocObserver: SimpleBlocDelegate(),
      );
    },
    (error, stackTrace) async {
      await getIt<IErrorService>().logException(error, stackTrace: stackTrace);
    },
  );
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    if (kDebugMode) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    }
  });
}
