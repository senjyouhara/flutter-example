
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {

  PermissionUtil._();

  // 获取文件存储权限
  static Future<bool> getStoragePermission() async {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        return true;
      }

      PermissionStatus status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      }

      if (Platform.isAndroid) {
        status = await Permission.storage.request();
      } else {
        return true;
      }

      if (status.isGranted) {
        debugPrint('Android: 存储权限已授予');
        return true;
      } else if (status.isPermanentlyDenied) {
        debugPrint('Android: 存储权限被永久拒绝，请前往设置开启');
        return false;
      } else {
        debugPrint('Android: 存储权限被拒绝');
        return false;
      }
  }





}