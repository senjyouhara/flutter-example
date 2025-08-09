import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';

Size get designSize {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  // 逻辑短边
  final logicalShortestSide =
      firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  // 逻辑长边
  final logicalLongestSide =
      firstView.physicalSize.longestSide / firstView.devicePixelRatio;
  // 缩放比例 designsize越小，元素越大
  const scaleFactor = 0.95;
  // 缩放后的逻辑短边和长边
  return Size(
    logicalShortestSide * scaleFactor,
    logicalLongestSide * scaleFactor,
  );
}

WebViewEnvironment? webViewEnvironment;
const bool inProduction = const bool.fromEnvironment("dart.vm.product");

webViewInit() async {
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
}