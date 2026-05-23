import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  static Future<void> capture(dynamic error, StackTrace stackTrace) async {
    await Sentry.captureException(error, stackTrace: stackTrace);
  }
}
