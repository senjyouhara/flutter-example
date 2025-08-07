
import 'dart:developer';

import 'package:example/components/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../main.dart';

enum WebviewType {
  HTML_TEXT,
  URL,
}

typedef dynamic JsChannelCallback(List<dynamic> arguments);

class BaseWebViewWidget extends StatefulWidget {

  final WebviewType webviewType;
  final String loadResource;
  final Map<String, JsChannelCallback>? jsChannelMap;
  final Function(InAppWebViewController controller)? onWebviewCreated;
  final bool? clearCache;

  const BaseWebViewWidget({
    super.key,
    required this.webviewType,
    required this.loadResource,
    this.jsChannelMap,
    this.clearCache,
    this.onWebviewCreated,
  });

  @override
  State<BaseWebViewWidget> createState() {
    return _BaseWebViewWidgetState();
  }

}

class _BaseWebViewWidgetState extends State<BaseWebViewWidget> {
  late InAppWebViewController webViewController;
  final webViewKey = GlobalKey();
  PullToRefreshController? pullToRefreshController;
  double progress = 0;

  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true,
      // 不允许缩放
      builtInZoomControls: false,
      // 支持HybridComposition
      useHybridComposition: true,
  );

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb ||
        ![TargetPlatform.iOS, TargetPlatform.android]
            .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController?.loadUrl(
              urlRequest:
              URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      key: webViewKey,
      webViewEnvironment: webViewEnvironment,
      initialSettings: settings,
      pullToRefreshController: pullToRefreshController,
      onWebViewCreated: (controller){
        webViewController = controller;

        if(widget.clearCache == true){
          InAppWebViewController.clearAllCache(includeDiskFiles: true);
        }

        if(widget.onWebviewCreated == null){
          if(widget.webviewType == WebviewType.HTML_TEXT){
            webViewController.loadData(data: widget.loadResource);
          } else if(widget.webviewType == WebviewType.URL){
            webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(widget.loadResource)));
          }
        } else {
          widget.onWebviewCreated?.call(controller);
        }

        // 注册jschannel通信回调
        widget.jsChannelMap?.forEach((handlerName, callback){
          webViewController.addJavaScriptHandler(handlerName: handlerName, callback: callback);
        });
      },
      onConsoleMessage: (controller, consoleMsg){
        log("consoleMessage, js打印内容: ${consoleMsg}");
      },
      onProgressChanged: (controller, progress) {
        if (progress == 100) {
          pullToRefreshController?.endRefreshing();
        }
        setState(() {
          this.progress = progress / 100;
        });
      },
      onLoadStart: (controller, url) {
        Loading.showLoading(duration: const Duration(seconds: 45));
      },
      onLoadStop: (controller, url) async {
        pullToRefreshController?.endRefreshing();
        Loading.dismissAll();
      },
      onReceivedError: (controller, request, error) {
        pullToRefreshController?.endRefreshing();
        Loading.dismissAll();
      },
      onPageCommitVisible: (controller, url){

      },
    );
  }
}