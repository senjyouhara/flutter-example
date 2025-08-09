import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class FileDirPath {
  FileDirPath._();

  ///获取文件保存路径
  static Future<String> prepareSaveDir() async {
    String localPath = (await _getSavedDir())!;
    final savedDir = Directory(localPath);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
    return localPath;
  }

  static Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;
    final Directory? downloadsDir;
    if (Platform.isAndroid) {
      try {
        downloadsDir = await getDownloadsDirectory();
        externalStorageDirPath = downloadsDir!.path;
        print('externalStorageDirPath: $externalStorageDirPath');
      } catch (err, st) {
        print('failed to get downloads path: $err, $st');
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      // var dir = (await _dirsOnIOS)[0]; // temporary
      // var dir = (await _dirsOnIOS)[1]; // applicationSupport
      // var dir = (await _dirsOnIOS)[2]; // library
      var dir = (await _dirsOnIOS)[3]; // applicationDocuments
      //var dir = (await _dirsOnIOS)[4]; // downloads
      dir ??= await getApplicationDocumentsDirectory();
      externalStorageDirPath = dir.absolute.path;
    }
    return externalStorageDirPath;
  }

  static Future<List<Directory?>> get _dirsOnIOS async {
    final temporary = await getTemporaryDirectory();
    final applicationSupport = await getApplicationSupportDirectory();
    final library = await getLibraryDirectory();
    final applicationDocuments = await getApplicationDocumentsDirectory();
    final downloads = await getDownloadsDirectory();
    final dirs = [
      temporary,
      applicationSupport,
      library,
      applicationDocuments,
      downloads
    ];
    return dirs;
  }

}