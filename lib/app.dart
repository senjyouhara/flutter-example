import 'package:example/pages/home/home_page.dart';
import 'package:example/pages/tabbar_page.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

Size get designSize {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  // 逻辑短边
  final logicalShortestSide = firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  // 逻辑长边
  final logicalLongestSide = firstView.physicalSize.longestSide / firstView.devicePixelRatio;
  // 缩放比例 designsize越小，元素越大
  const scaleFactor = 0.95;
  // 缩放后的逻辑短边和长边
  return Size(logicalShortestSide * scaleFactor, logicalLongestSide * scaleFactor);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // toast必须为顶层组件
    return OKToast(
      // 屏幕适配父组件
      child: ScreenUtilInit(
        designSize: designSize,
        builder: (context, child){
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
    );
  }
}
