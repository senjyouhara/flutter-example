import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteUtils {
  RouteUtils._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String location,
  ) {
    return context.push<T>(location);
  }

  static void pushNamedAndRemoveUntil(
    BuildContext context,
    String location,
  ) {
    context.go(location);
  }

  static void pushReplacementNamed(
    BuildContext context,
    String location,
  ) {
    context.go(location);
  }

  static void go(BuildContext context, String location) {
    context.go(location);
  }

  static void pop(BuildContext context) {
    context.pop();
  }

  static void popOfData<T extends Object?>(BuildContext context, {T? data}) {
    context.pop<T>(data);
  }
}
