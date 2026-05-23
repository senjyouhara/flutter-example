import 'package:example/core/sentry/SentryTalkerObserver.dart';
import 'package:talker/talker.dart';

final talker = Talker(
  observer: SentryTalkerObserver(),
  settings: TalkerSettings(enabled: true, useConsoleLogs: true),
);
