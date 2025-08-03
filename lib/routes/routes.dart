import 'package:example/pages/search/search_page.dart';
import 'package:example/pages/tabbar_page.dart';
import 'package:flutter/material.dart';

import '../pages/webview/webview_page.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesPath.index:
        return pageRoute(TabbarPage(), settings: settings);
      case RoutesPath.webviewPage:
        return pageRoute(WebviewPage(title: "",), settings: settings);
      case RoutesPath.searchPage:
        return pageRoute(SearchPage(), settings: settings);

      default:
        return pageRoute(
          Scaffold(
            body: SafeArea(
              child: Center(child: Text("未知路由： ${settings.name}")),
            ),
          ),
        );
    }
  }

  static Route<dynamic> pageRoute(
    Widget page, {
    RouteSettings? settings,
    bool? fullscreenDialog,
    bool? maintainState,
    bool? allowSnapshotting,
  }) {
    return MaterialPageRoute(
      builder: (c) => page,
      settings: settings,
      fullscreenDialog: fullscreenDialog ?? false,
      maintainState: maintainState ?? true,
      allowSnapshotting: allowSnapshotting ?? true,
    );
  }
}

class RoutesPath {
  static const String index = "/";

  static const String webviewPage = "/webview";

  static const String searchPage = "/search";
}
