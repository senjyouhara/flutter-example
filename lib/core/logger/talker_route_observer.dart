import 'package:flutter/widgets.dart';
import 'package:talker/talker.dart';

class TalkerRouteObserver extends NavigatorObserver {
  final Talker talker;

  TalkerRouteObserver(this.talker);

  void _logRoute(String action, Route<dynamic>? route) {
    final routeName =
        route?.settings.name ??
        route?.settings.arguments?.toString() ??
        route.toString();

    talker.info('[ROUTE] $action -> $routeName');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logRoute('PUSH', route);

    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logRoute('POP', route);

    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _logRoute('REPLACE', newRoute);

    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logRoute('REMOVE', route);

    super.didRemove(route, previousRoute);
  }
}
