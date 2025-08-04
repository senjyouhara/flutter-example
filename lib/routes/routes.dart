import 'package:example/pages/login/login_page.dart';
import 'package:example/pages/register/register_page.dart';
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
      case RoutesPath.registerPage:
        return pageRoute(RegisterPage(), settings: settings);
      case RoutesPath.loginPage:
        return pageRoute(LoginPage(), settings: settings);

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

  // static String routeBeforeHook(RouteSettings settings) {
  //   /// Global.prefs 是全局的 SharedPreferences 实例
  //   /// SharedPreferences 是常用的本地存储的插件
  //   final token = Global.prefs.getString('token') ?? '';
  //   if (token != '') {
  //     if (settings.name == 'login') {
  //       return 'index';
  //     }
  //     return settings.name!;
  //   }
  //   return 'login';
  // }

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

  static const String loginPage = "/login";

  static const String registerPage = "/register";
}
