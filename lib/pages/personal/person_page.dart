import 'package:example/extensions/image_extension.dart';
import 'package:example/pages/personal/update_dialog.dart';
import 'package:example/utils/permission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../routes/route_utils.dart';
import '../../routes/routes.dart';
import '../login/login_vm.dart';

class PersonalPage extends HookConsumerWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _userInfo(context, ref),
              _userMenus(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfo(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      alignment: Alignment.center,
      height: 180.h,
      decoration: const BoxDecoration(color: Color(0xff018b7d)),
      padding: EdgeInsets.only(top: statusBarHeight),
      child: FractionallySizedBox(
        heightFactor: 1,
        child: GestureDetector(
          onTap: () {
            if (!authState.isLoggedIn) {
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
                  'anonymous.jpg'.img,
                  fit: BoxFit.cover,
                  width: 50.w,
                  height: 50.h,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  authState.userInfo?.username ?? '未登录',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userMenus(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return Container(
      padding: EdgeInsets.all(10.w),
      child: Column(
        spacing: 8.w,
        children: [
          authState.isLoggedIn
              ? getMenu(
                  '我的收藏',
                  onTap: () {
                    RouteUtils.pushNamed(
                      context,
                      RoutesPath.favoritePage,
                      arguments: {},
                    );
                  },
                )
              : const SizedBox(),
          getMenu(
            '检查更新',
            onTap: () async {
              final permissionState =
                  await PermissionUtil.getStoragePermission();
              if (permissionState) {
                if (!context.mounted) {
                  return;
                }
                try {
                  await UpdateDialog.showUpdateDialog(
                    context,
                    '1.修复已知bug\n2.优化用户体验',
                    false,
                  );
                } catch (_) {
                  showToast('下载失败');
                }
              } else {
                showToast('未授予存储权限，请开启再使用');
                openAppSettings();
              }
            },
          ),
          getMenu(
            '关于我们',
            onTap: () {
              RouteUtils.pushNamed(
                context,
                RoutesPath.aboutPage,
                arguments: {},
              );
            },
          ),
          authState.isLoggedIn
              ? getMenu(
                  '退出登录',
                  onTap: () async {
                    try {
                      await ref.read(authProvider.notifier).logout();
                    } catch (_) {}
                  },
                )
              : const SizedBox(),
        ],
      ),
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
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            Icon(Icons.chevron_right, size: 20.w),
          ],
        ),
      ),
    );
  }
}
