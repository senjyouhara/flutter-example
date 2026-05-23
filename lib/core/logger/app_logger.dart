import 'logger.dart';

class AppLogger {
  static void auth(String msg) {
    talker.info('[AUTH] $msg');
  }

  static void network(String msg) {
    talker.info('[NETWORK] $msg');
  }

  static void chat(String msg) {
    talker.info('[CHAT] $msg');
  }

  static void upload(String msg) {
    talker.info('[UPLOAD] $msg');
  }

  static void error(String msg, Object error, StackTrace? stack) {
    talker.error('error $msg', error, stack);
  }
}
