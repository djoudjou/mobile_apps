import 'dart:io';
import 'dart:ui' as ui show window;

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:familytrusts/src/domain/error/i_error_service.dart';
import 'package:familytrusts/src/helper/log_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

@LazySingleton(as: IErrorService)
class SentryErrorService with IErrorService, LogMixin {
  SentryErrorService();

  Future<void> logEvent(
    String message,
    SentryLevel severity,
    Map<String, dynamic>? data,
  ) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final SentryEvent event = SentryEvent(
      message: SentryMessage(message),
      release: '${info.version}_${info.buildNumber}',
      environment: 'qa',
      extra: data,
      level: severity,
    );

    try {
      await Sentry.captureEvent(event);
      /*
      if (response.isSuccessful) {
        log('Success! Event ID: ${response.eventId}');
      } else {
        log('Failed to report to Sentry.io: ${response.error}');
      }
       */
    } catch (e, stackTrace) {
      log('Exception whilst reporting to Sentry.io\n$stackTrace');
    }
  }

  @override
  Future<void> logError(String message, [Map<String, dynamic>? data]) =>
      logEvent(message, SentryLevel.error, data);

  @override
  Future<void> logException(
    Object error, {
    String? message,
    StackTrace? stackTrace,
  }) async {
    log('Caught error: $error\n$stackTrace');

    final PackageInfo info = await PackageInfo.fromPlatform();

    final Map<String, dynamic> extra = <String, dynamic>{};

    if (defaultTargetPlatform == TargetPlatform.android) {
      extra['device_info'] = (await DeviceInfoPlugin().androidInfo).model;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      extra['device_info'] = (await DeviceInfoPlugin().iosInfo).model;
    }

    final String mode = _isInDebugMode ? 'checked' : 'release';

    final Map<String, String> tags = {};
    tags['message'] = message ?? "";
    tags['platform'] =
        defaultTargetPlatform.toString().substring('TargetPlatform.'.length);
    tags['package_name'] = info.packageName;
    tags['build_number'] = info.buildNumber;
    tags['version'] = info.version;
    tags['mode'] = mode;
    tags['locale'] = ui.window.locale.toString();

    final ConnectivityResult connectivity =
        await Connectivity().checkConnectivity();
    tags['connectivity'] =
        connectivity.toString().substring('ConnectivityResult.'.length);

    final Map<String, dynamic> uiValues = <String, dynamic>{};
    uiValues['locale'] = ui.window.locale.toString();
    uiValues['pixel_ratio'] = ui.window.devicePixelRatio;
    uiValues['default_route'] = ui.window.defaultRouteName;
    uiValues['physical_size'] = [
      ui.window.physicalSize.width,
      ui.window.physicalSize.height
    ];
    uiValues['text_scale_factor'] = ui.window.textScaleFactor;
    uiValues['view_insets'] = [
      ui.window.viewInsets.left,
      ui.window.viewInsets.top,
      ui.window.viewInsets.right,
      ui.window.viewInsets.bottom
    ];
    uiValues['padding'] = [
      ui.window.padding.left,
      ui.window.padding.top,
      ui.window.padding.right,
      ui.window.padding.bottom
    ];
    extra['ui'] = uiValues;

    //final Map<String, dynamic> memory = <String, dynamic>{};
    //memory['phys_total'] = '${SysInfo.getTotalPhysicalMemory() ~/ megabyte} MB';
    //memory['phys_free'] = '${SysInfo.getFreePhysicalMemory() ~/ megabyte} MB';
    //memory['virt_total'] = '${SysInfo.getTotalVirtualMemory() ~/ megabyte} MB';
    //memory['virt_free'] = '${SysInfo.getFreeVirtualMemory() ~/ megabyte} MB';
    //extra['memory'] = memory;

    extra['dart_version'] = Platform.version;

    final SentryEvent event = SentryEvent(
      exceptions: [
        SentryException(
          value: message,
          type: '',
        )
      ],
      release: '${info.version}_${info.buildNumber}',
      environment: 'qa',
      tags: tags,
      extra: extra,
      level: SentryLevel.fatal,
    );

    if (_isInDebugMode) {
      log(message ?? "Unexpected error", stackTrace: stackTrace);
      log('In dev mode. Not sending report to Sentry.io.');
      log("Sentry Event > $event");
      log("Sentry tags > $tags");
      log("Sentry extra > $extra");
      return;
    }

    log('Reporting to Sentry.io...');
    try {
      await Sentry.captureEvent(event, stackTrace: stackTrace);
      /*
      if (response.isSuccessful) {
        log('Success! Event ID: ${response.eventId}');
      } else {
        log('Failed to report to Sentry.io: ${response.error}');
      }
       */
    } catch (e, stackTrace) {
      log('Exception whilst reporting to Sentry.io\n$stackTrace');
    }
  }

  @override
  Future<void> logInfo(String message, [Map<String, dynamic>? data]) =>
      logEvent(message, SentryLevel.info, data);

  @override
  Future<void> logWarning(String message, [Map<String, dynamic>? data]) =>
      logEvent(message, SentryLevel.warning, data);

  bool get _isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
