import 'package:example/pages/knowledge/detail/knowledge_detail_page.dart';
import 'package:example/pages/login/login_page.dart';
import 'package:example/pages/personal/favorite/favorite_page.dart';
import 'package:example/pages/register/register_page.dart';
import 'package:example/pages/search/search_page.dart';
import 'package:example/pages/tabbar_page.dart';
import 'package:flutter/material.dart';
import '../pages/about/about_page.dart';
import '../pages/webview/webview_page.dart';

//定义路由列表
final Map<String, Function> routes = {
  RoutesPath.index: (RouteSettings settings) =>
      Routes.pageRoute(TabbarPage(), settings: settings),
  RoutesPath.webviewPage: (RouteSettings settings) =>
      Routes.pageRoute(WebviewPage(), settings: settings),
  RoutesPath.searchPage: (RouteSettings settings) =>
      Routes.pageRoute(SearchPage(), settings: settings),
  RoutesPath.registerPage: (RouteSettings settings) =>
      Routes.pageRoute(RegisterPage(), settings: settings),
  RoutesPath.loginPage: (RouteSettings settings) =>
      Routes.pageRoute(LoginPage(), settings: settings),
  RoutesPath.favoritePage: (RouteSettings settings) =>
      Routes.pageRoute(FavoritePage(), settings: settings),
  RoutesPath.aboutPage: (RouteSettings settings) =>
      Routes.pageRoute(AboutPage(), settings: settings),
  RoutesPath.knowledgeDetailPage: (RouteSettings settings) =>
      Routes.pageRoute(KnowledgeDetailPage(), settings: settings),
  //未来只需要在这儿新增路由和方法就可以了
};

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    String? routeName = settings.name;
    Function? pageContentBuilder = routes[routeName];
    if (pageContentBuilder != null) {
      final Route route = pageContentBuilder(settings);
      return route;
    }

    return pageRoute(
      Scaffold(
        body: SafeArea(child: Center(child: Text("未知路由： ${settings.name}"))),
      ),
    );

    // switch (settings.name) {
    //   case RoutesPath.index:
    //     return pageRoute(TabbarPage(), settings: settings);
    //   case RoutesPath.webviewPage:
    //     return pageRoute(WebviewPage(title: "",), settings: settings);
    //   case RoutesPath.searchPage:
    //     return pageRoute(SearchPage(), settings: settings);
    //   case RoutesPath.registerPage:
    //     return pageRoute(RegisterPage(), settings: settings);
    //   case RoutesPath.loginPage:
    //     return pageRoute(LoginPage(), settings: settings);
    //   case RoutesPath.favoritePage:
    //     return pageRoute(FavoritePage(), settings: settings);
    //   case RoutesPath.aboutPage:
    //     return pageRoute(AboutPage(), settings: settings);
    //   case RoutesPath.knowledgeDetailPage:
    //     return pageRoute(KnowledgeDetailPage(), settings: settings);
    //
    //   default:
    //     return pageRoute(
    //       Scaffold(
    //         body: SafeArea(
    //           child: Center(child: Text("未知路由： ${settings.name}")),
    //         ),
    //       ),
    //     );
    // }
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

  static const String knowledgeDetailPage = "/knowledge/detail";

  static const String loginPage = "/login";

  static const String registerPage = "/register";

  static const String favoritePage = "/favorite";

  static const String aboutPage = "/about";
}
