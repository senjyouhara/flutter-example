import 'package:example/core/logger/logger.dart';
import 'package:example/routes/routes.dart';
import 'package:example/utils/permission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

import 'config.dart';

final riverpodLogger = TalkerRiverpodObserver(talker: talker);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    PermissionUtil.getStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    // toast必须为顶层组件
    return ProviderScope(
      observers: [riverpodLogger],
      child: OKToast(
        // 屏幕适配父组件
        child: ScreenUtilInit(
          designSize: designSize,
          builder: (context, child) {
            return MaterialApp.router(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              routerConfig: Routes.router,
            );
          },
        ),
      ),
    );
  }
}
