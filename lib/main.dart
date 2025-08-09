import 'package:example/utils/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'config.dart';


void main() async {
  // 初始化插件前需调用初始化代码 runApp()函数之前
  WidgetsFlutterBinding.ensureInitialized();

  /// 初始持久化数据
  await SpUtil.getInstance();

  await webViewInit();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 竖屏，顶部朝上
    DeviceOrientation.portraitDown, // 竖屏，顶部朝下
  ]);

  runApp(MyApp());
}