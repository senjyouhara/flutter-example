import 'package:example/extensions/image_extension.dart';
import 'package:example/pages/personal/person_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../routes/route_utils.dart';
import '../../routes/routes.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PersonViewModel>(create: (context) => vm),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [_userInfo(), _userMenus()]),
          ),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Consumer<LoginViewModel>(
      builder: (context, vm, child){
        return Container(
            alignment: Alignment.center,
            height: 180.h,
            decoration: BoxDecoration(color: Color(0xff018b7d)),
            child: FractionallySizedBox(
              heightFactor: 1,
              child: GestureDetector(
                onTap: (){
                  if(vm.userInfo == null){
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
            )
        );
      },
    );
  }

  Widget _userMenus() {
    return Consumer<LoginViewModel>(builder: (context, vm, child){
      return Container(
        padding: EdgeInsets.all(10.w),
        child: Column(
          spacing: 8.w,
          children: [
            vm.userInfo != null ? getMenu("我的收藏", onTap: (){
              RouteUtils.pushNamed(
                context,
                RoutesPath.favoritePage,
                arguments: {},
              );
            }) : SizedBox(),
            getMenu("检查更新", onTap: (){

            }),
            getMenu("关于我们", onTap: (){

            }),
            vm.userInfo != null ? getMenu("退出登录", onTap: (){
              try {
                vm.logout();
              } catch (e){
                print("err ${e}");
              }
            }) : SizedBox(),
          ],
        ),
      );
    });
  }

  Widget getMenu(String title, {GestureTapCallback? onTap}){
    return  GestureDetector(
      onTap: (){
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
            Text(title, style: TextStyle(fontSize: 14, color: Colors.black54),),
            Icon(Icons.chevron_right, size: 20.w, ),
          ],
        ),
      ),
    );
  }
}
