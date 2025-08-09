import 'dart:math';

import 'package:dio/dio.dart';
import 'package:example/pages/register/register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../components/loading.dart';
import '../../routes/route_utils.dart';
import '../../routes/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() {
    return _RegisterPageState();
  }
}

class FormStateLogic {
  final formKey = GlobalKey<FormState>();

  final UsernameController = TextEditingController();
  final PasswordController = TextEditingController();
  final RePasswordController = TextEditingController();

  String userName = "";
  String password = "";
  String rePassword = "";
}

class _RegisterPageState extends State<RegisterPage> {
  final _logic = FormStateLogic();
  final vm = RegisterViewModel();

  void onSubmit() async {
    // 隐藏软键盘
    // SystemChannels.textInput.invokeMethod("TextInput.hide");
    FocusScope.of(context).unfocus();
    if (_logic.formKey.currentState!.validate()) {
      Loading.showLoading();
      try {
        final result = await vm.register(
          _logic.userName,
          _logic.password,
          _logic.rePassword,
        );
        if(result){
          showToast("注册成功！");
          onRegister();
        }
        print("result: ${result}");
      } on DioException catch (e){
        print("err: ${e}");
      }
      Loading.dismissAll();
    }
  }

  void onRegister() {
    RouteUtils.pushReplacementNamed(
      context,
      RoutesPath.loginPage,
      arguments: {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        backgroundColor: Color(0xff018b7d),
        body: SafeArea(
          bottom: false,
          top: false,
          child: Container(
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
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        decoration: textFormCommonInputDecoration("用户名"),
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                          FilteringTextInputFormatter.deny(RegExp(r"\s*"))
                        ],
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
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        decoration: textFormCommonInputDecoration("密码"),
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                          FilteringTextInputFormatter.deny(RegExp(r"\s*"))
                        ],
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 5) {
                            return "密码最少5位";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _logic.RePasswordController,
                        onChanged: (val) {
                          _logic.RePasswordController.text = val;
                          _logic.rePassword = val;
                        },
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        decoration: textFormCommonInputDecoration("确认密码"),
                        textInputAction: TextInputAction.none,
                        onEditingComplete: (){
                          onSubmit();
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                          FilteringTextInputFormatter.deny(RegExp(r"\s*"))
                        ],
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 5) {
                            return "确认密码最少5位";
                          }

                          if (value != _logic.password) {
                            return "两次密码不一致";
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
                            "注册",
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
                            "已有账号？前往登录",
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
