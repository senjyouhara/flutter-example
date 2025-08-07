import 'package:example/utils/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'app.dart';

WebViewEnvironment? webViewEnvironment;

void main() async {
  // 初始化插件前需调用初始化代码 runApp()函数之前
  WidgetsFlutterBinding.ensureInitialized();

  /// 初始持久化数据
  await SpUtil.getInstance();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    assert(availableVersion != null,
    'Failed to find an installed WebView2 Runtime or non-stable Microsoft Edge installation.');

    webViewEnvironment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(userDataFolder: 'YOUR_CUSTOM_PATH'));
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }


  runApp(MyApp());
}