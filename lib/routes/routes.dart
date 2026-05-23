import 'package:example/pages/about/about_page.dart';
import 'package:example/pages/hot_key/hot_key_page.dart';
import 'package:example/pages/home/home_page.dart';
import 'package:example/pages/knowledge/detail/knowledge_detail_page.dart';
import 'package:example/pages/knowledge/knowledge_page.dart';
import 'package:example/pages/login/login_page.dart';
import 'package:example/pages/personal/favorite/favorite_page.dart';
import 'package:example/pages/personal/person_page.dart';
import 'package:example/pages/register/register_page.dart';
import 'package:example/pages/search/search_page.dart';
import 'package:example/pages/tabbar_page.dart';
import 'package:example/pages/webview/webview_page.dart';
import 'package:example/routes/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static final GoRouter router = GoRouter(
    navigatorKey: RouteUtils.navigatorKey,
    initialLocation: RoutesPath.index,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return TabbarPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutesPath.index,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutesPath.hotKeyPage,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HotKeyPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutesPath.knowledgePage,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: KnowledgePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutesPath.personal,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: PersonalPage()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutesPath.loginPage,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutesPath.registerPage,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RoutesPath.searchPage,
        builder: (context, state) => SearchPage(
          initialKeyword: state.uri.queryParameters['q'] ?? '',
        ),
      ),
      GoRoute(
        path: RoutesPath.webviewPage,
        builder: (context, state) => WebviewPage(
          title: state.uri.queryParameters['title'],
          url: state.uri.queryParameters['url'],
        ),
      ),
      GoRoute(
        path: RoutesPath.favoritePage,
        builder: (context, state) => const FavoritePage(),
      ),
      GoRoute(
        path: RoutesPath.aboutPage,
        builder: (context, state) => AboutPage(),
      ),
      GoRoute(
        path: RoutesPath.knowledgeDetailPage,
        builder: (context, state) => KnowledgeDetailPage(
          pid: int.tryParse(state.pathParameters['pid'] ?? ''),
          cid: int.tryParse(state.pathParameters['cid'] ?? ''),
          title: state.uri.queryParameters['title'],
        ),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: Center(child: Text('未知路由： ${state.uri}')),
        ),
      );
    },
  );
}

class RoutesPath {
  static const String index = '/';
  static const String hotKeyPage = '/hot';
  static const String knowledgePage = '/knowledge';
  static const String personal = '/personal';

  static const String webviewPage = '/webview';
  static const String searchPage = '/search';
  static const String knowledgeDetailPage = '/knowledge/:pid/:cid';
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String favoritePage = '/favorite';
  static const String aboutPage = '/about';

  static String searchPageLocation({String? keyword}) {
    final queryParameters = <String, String>{};
    if (keyword?.isNotEmpty ?? false) {
      queryParameters['q'] = keyword!;
    }
    return Uri(
      path: searchPage,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    ).toString();
  }

  static String webviewPageLocation({String? title, String? url}) {
    final queryParameters = <String, String>{};
    if (title?.isNotEmpty ?? false) {
      queryParameters['title'] = title!;
    }
    if (url?.isNotEmpty ?? false) {
      queryParameters['url'] = url!;
    }
    return Uri(
      path: webviewPage,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    ).toString();
  }

  static String knowledgeDetailPageLocation({
    required int pid,
    required int cid,
    String? title,
  }) {
    final queryParameters = <String, String>{};
    if (title?.isNotEmpty ?? false) {
      queryParameters['title'] = title!;
    }
    return Uri(
      path: '$knowledgePage/$pid/$cid',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    ).toString();
  }
}
