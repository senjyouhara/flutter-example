import 'package:dio/dio.dart';
import 'package:example/pages/register/register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';

import '../../components/loading.dart';
import '../../routes/route_utils.dart';
import '../../routes/routes.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final rePasswordController = useTextEditingController();

    void onRegister() {
      RouteUtils.pushReplacementNamed(
        context,
        RoutesPath.loginPage,
        arguments: {},
      );
    }

    Future<void> onSubmit() async {
      FocusScope.of(context).unfocus();
      final isValid = formKey.currentState?.saveAndValidate() ?? false;
      if (!isValid) {
        return;
      }

      final formValue = formKey.currentState!.value;
      final username = formValue['username'] as String? ?? '';
      final password = formValue['password'] as String? ?? '';
      final rePassword = formValue['rePassword'] as String? ?? '';

      Loading.showLoading();
      try {
        final result = await ref.read(registerActionProvider).register(
          username,
          password,
          rePassword,
        );
        if (result) {
          showToast('注册成功！');
          if (!context.mounted) {
            return;
          }
          onRegister();
        }
      } on DioException catch (_) {
      } finally {
        Loading.dismissAll();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xff018b7d),
      body: Container(
        padding: EdgeInsets.all(10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormBuilder(
              key: formKey,
              child: Column(
                spacing: 20.h,
                children: [
                  FormBuilderTextField(
                    name: 'username',
                    controller: usernameController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: textFormCommonInputDecoration('用户名'),
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.deny(RegExp(r'\s*')),
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: '用户名最少5位'),
                      FormBuilderValidators.minLength(5, errorText: '用户名最少5位'),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'password',
                    obscureText: true,
                    controller: passwordController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: textFormCommonInputDecoration('密码'),
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.deny(RegExp(r'\s*')),
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: '密码最少5位'),
                      FormBuilderValidators.minLength(5, errorText: '密码最少5位'),
                    ]),
                  ),
                  FormBuilderTextField(
                    name: 'rePassword',
                    obscureText: true,
                    controller: rePasswordController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: textFormCommonInputDecoration('确认密码'),
                    textInputAction: TextInputAction.none,
                    onEditingComplete: onSubmit,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.deny(RegExp(r'\s*')),
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: '确认密码最少5位'),
                      FormBuilderValidators.minLength(5, errorText: '确认密码最少5位'),
                      (valueCandidate) {
                        final passwordValue =
                            formKey.currentState?.fields['password']?.value
                                as String?;
                        if (valueCandidate != passwordValue) {
                          return '两次密码不一致';
                        }
                        return null;
                      },
                    ]),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: OutlinedButton(
                      onPressed: onSubmit,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '注册',
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
                        '已有账号？前往登录',
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
}

InputDecoration textFormCommonInputDecoration(String labelText) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 0.5.w),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.w),
    ),
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.white),
  );
}
