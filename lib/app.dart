import 'package:example/routes/routes.dart';
import 'package:example/utils/permission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';

import 'config.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await PermissionUtil.getStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    // toast必须为顶层组件
    return ProviderScope(
      child: OKToast(
        // 屏幕适配父组件
        child: ScreenUtilInit(
          designSize: designSize,
          builder: (context, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              // home: const TabbarPage(),
              onGenerateRoute: Routes.generateRoutes,
              initialRoute: RoutesPath.index,
            );
          },
        ),
      ),
    );
  }
}
