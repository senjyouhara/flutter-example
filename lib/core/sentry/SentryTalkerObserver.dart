import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';

class SentryTalkerObserver extends TalkerObserver {
  @override
  void onError(TalkerError err) {
    Sentry.captureException(err.error, stackTrace: err.stackTrace);

    super.onError(err);
  }
}
