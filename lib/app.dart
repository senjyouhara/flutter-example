import 'package:example/pages/login/login_vm.dart';
import 'package:example/routes/routes.dart';
import 'package:example/utils/permissionUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'config.dart';


class MyApp extends StatefulWidget {

  MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{

  final LoginViewModel vm = LoginViewModel();

  @override
  void initState() {
    vm.getInfo();
  }


  @override
  void didChangeDependencies() async {
    /// 申请写文件权限
    var result = await PermissionUtil.getStoragePermission();
  }


  @override
  Widget build(BuildContext context) {
    // toast必须为顶层组件
    return OKToast(
      // 屏幕适配父组件
      child: ScreenUtilInit(
        designSize: designSize,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<LoginViewModel>(create: (context) => vm),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              // home: const TabbarPage(),
              onGenerateRoute: Routes.generateRoutes,
              initialRoute: RoutesPath.index,
            ),
          );
        },
      ),
    );
  }
}
