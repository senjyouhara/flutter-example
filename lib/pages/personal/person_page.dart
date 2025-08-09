import 'dart:io';
import 'package:example/pages/personal/update_dialog.dart';
import 'package:install_plugin_v3/install_plugin_v3.dart';
import 'package:dio/dio.dart';
import 'package:example/extensions/image_extension.dart';
import 'package:example/pages/personal/person_vm.dart';
import 'package:example/utils/filedir_path.dart';
import 'package:example/utils/permissionUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../components/loading.dart';
import '../../routes/route_utils.dart';
import '../../routes/routes.dart';
import '../../utils/request/request.dart';
import '../login/login_vm.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() {
    return _PersonalPageState();
  }
}

class _PersonalPageState extends State<PersonalPage> {
  final PersonViewModel vm = PersonViewModel();

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PersonViewModel>(create: (context) => vm),
      ],
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(children: [_userInfo(), _userMenus()]),
          ),
        ),
      ),
    );
  }

  Widget _userInfo() {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Consumer<LoginViewModel>(
      builder: (context, vm, child) {
        return Container(
          alignment: Alignment.center,
          height: 180.h,
          decoration: BoxDecoration(color: Color(0xff018b7d)),
          padding: EdgeInsets.only(top: statusBarHeight),
          child: FractionallySizedBox(
            heightFactor: 1,
            child: GestureDetector(
              onTap: () {
                if (vm.userInfo == null) {
                  RouteUtils.pushNamed(
                    context,
                    RoutesPath.loginPage,
                    arguments: {},
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "anonymous.jpg".img,
                      fit: BoxFit.cover,
                      width: 50.w,
                      height: 50.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      vm.userInfo?.username ?? "未登录",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _userMenus() {
    return Consumer<LoginViewModel>(
      builder: (context, vm, child) {
        return Container(
          padding: EdgeInsets.all(10.w),
          child: Column(
            spacing: 8.w,
            children: [
              vm.userInfo != null
                  ? getMenu(
                      "我的收藏",
                      onTap: () {
                        RouteUtils.pushNamed(
                          context,
                          RoutesPath.favoritePage,
                          arguments: {},
                        );
                      },
                    )
                  : SizedBox(),
              getMenu(
                "检查更新",
                onTap: () async {
                  final permissionState =
                      await PermissionUtil.getStoragePermission();
                  if (permissionState) {
                    // final localPath = await FileDirPath.prepareSaveDir();
                    // String savePath = '$localPath/flutter-example-lastest.apk';
                    // File savePathFile = new File(savePath);
                    // if (!savePathFile.existsSync()) {
                    //   await savePathFile.create();
                    // }
                    // 权限被授予
                    // Loading.showLoading(title: "检查更新中……");
                    try {
                      // var data = await Request.get<String>("https://github.com/senjyouhara/flutter-example/releases/expanded_assets/lastest",
                      //   options: Options(
                      //       headers: {
                      //         HttpHeaders.refererHeader: "https://github.com/senjyouhara/flutter-example/releases/download/lastest/flutter-example-lastest.apk",
                      //         HttpHeaders.userAgentHeader: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36"
                      //       }
                      //   ),
                      // );
                      //
                      // var sha256 = "";
                      // if(data.data?.isNotEmpty == true &&
                      //     RegExp("(?<=sha256:)[a-zA-Z0-9]+(?=<\/)").hasMatch(data.data!)
                      // ){
                      //   var input = RegExp("(?<=sha256:)[a-zA-Z0-9]+(?=<\/)").stringMatch(data.data!);
                      //   sha256 = input??"";
                      // }

                      await UpdateDialog.showUpdateDialog(context, '1.修复已知bug\n2.优化用户体验', false);
                    } catch (e) {
                      print("err: ${e}");
                      // Loading.dismissAll();
                      showToast("下载失败");
                    }
                  } else {
                    showToast("未授予存储权限，请开启再使用");
                    // 权限被拒绝 打开手机上该App的权限设置页面
                    openAppSettings();
                  }
                },
              ),
              getMenu(
                "关于我们",
                onTap: () {
                  RouteUtils.pushNamed(
                    context,
                    RoutesPath.aboutPage,
                    arguments: {},
                  );
                },
              ),
              vm.userInfo != null
                  ? getMenu(
                      "退出登录",
                      onTap: () {
                        try {
                          vm.logout();
                        } catch (e) {
                          print("err ${e}");
                        }
                      },
                    )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }

  Widget getMenu(String title, {GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          border: Border.all(color: Colors.black45),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.black54)),
            Icon(Icons.chevron_right, size: 20.w),
          ],
        ),
      ),
    );
  }
}
