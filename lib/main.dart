import 'dart:async';
import 'package:example/utils/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/logger/logger.dart';
import 'app.dart';
import 'config.dart';

void main() async {
  // 初始化插件前需调用初始化代码 runApp()函数之前
  WidgetsFlutterBinding.ensureInitialized();

  /// 初始持久化数据
  await SpUtil.getInstance();

  await webViewInit();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 竖屏，顶部朝上
    DeviceOrientation.portraitDown, // 竖屏，顶部朝下
  ]);

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://xxxxxxxx@o0.ingest.sentry.io/0';

      // 采样率（性能监控）
      options.tracesSampleRate = 0.2;

      // Release版本
      options.release = '1.0.0';

      // 环境
      options.environment = 'development';
    },
    appRunner: () {
      runZonedGuarded(
        () {
          FlutterError.onError = (FlutterErrorDetails details) {
            talker.handle(details.exception, details.stack);
          };

          runApp(const MyApp());
        },
        (error, stack) {
          talker.handle(error, stack);
        },
      );
    },
  );

  // 小白条、导航栏沉浸
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
}
