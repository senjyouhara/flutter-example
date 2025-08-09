import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../components/loading.dart';
import '../../config.dart';
import '../../constants/Sp_constants.dart';
import '../../routes/route_utils.dart';
import '../../routes/routes.dart';
import '../../utils/sp_util.dart';
import 'login_vm.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class FormStateLogic {
  final formKey = GlobalKey<FormState>();

  final UsernameController = TextEditingController();
  final PasswordController = TextEditingController();

  String userName = "";
  String password = "";
}

class _LoginPageState extends State<LoginPage> {
  final _logic = FormStateLogic();

  @override
  void initState() {
    super.initState();
    if(inProduction){
      _logic.userName = "a7790";
      _logic.UsernameController.text = "a7790";
      _logic.password = "a77901";
      _logic.PasswordController.text = "a77901";
    }
  }

  void onSubmit() async {
    // 隐藏软键盘
    // SystemChannels.textInput.invokeMethod("TextInput.hide");
    FocusScope.of(context).unfocus();
    if (_logic.formKey.currentState!.validate()) {
      try {
        Loading.showLoading();
        final result = await context.read<LoginViewModel>().login(
          _logic.userName,
          _logic.password,
        );
        print("result: ${result}");
        Loading.dismissAll();
        showToast("登录成功");
        SpUtil.setMap(SpConstants.userInfo, result.toJson());
        RouteUtils.pushReplacementNamed(
          context,
          RoutesPath.index,
          arguments: {
            "index": 3
          },
        );
      } catch (e) {
        print("err: ${e}");
        Loading.dismissAll();
      }
    }
  }

  void onRegister() {
    RouteUtils.pushReplacementNamed(
      context,
      RoutesPath.registerPage,
      arguments: {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff018b7d),
      body: Container(
        padding: EdgeInsets.all(10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _logic.formKey,
              child: Column(
                spacing: 20.h,
                children: [
                  TextFormField(
                    controller: _logic.UsernameController,
                    onChanged: (val) {
                      _logic.UsernameController.text = val;
                      _logic.userName = val;
                    },
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.deny(RegExp(r"\s*"))
                    ],
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: textFormCommonInputDecoration("用户名"),
                    validator: (value) {
                      if (value == "" ||
                          value == null ||
                          value.length < 5) {
                        return "用户名最少5位";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _logic.PasswordController,
                    onChanged: (val) {
                      _logic.PasswordController.text = val;
                      _logic.password = val;
                    },
                    textInputAction: TextInputAction.none,
                    onEditingComplete: (){
                      onSubmit();
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.deny(RegExp(r"\s*"))
                    ],
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: textFormCommonInputDecoration("密码"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length < 5) {
                        return "密码最少5位";
                      }
                      return null;
                    },
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: OutlinedButton(
                      onPressed: onSubmit,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white), // 修改边框颜色
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // 圆角大小
                        ),
                      ),
                      child: Text(
                        "登录",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: TextButton(
                      onPressed: onRegister,
                      child: Text(
                        "没有账号？前往注册",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration textFormCommonInputDecoration(String labelText) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 0.5.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.w),
      ),
      labelText: labelText ?? "请输入",
      labelStyle: TextStyle(color: Colors.white),
    );
  }

  Widget commonTextForm(TextFormField config, String labelText) {
    return TextFormField(
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: textFormCommonInputDecoration(labelText),
    );
  }
}
