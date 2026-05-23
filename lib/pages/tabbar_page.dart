import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../components/navigation_bar/navigation_bar_widget.dart';

class TabbarPage extends StatelessWidget {
  const TabbarPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      navigationShell: navigationShell,
      tabs: [
        LabelIcons(label: '首页', icon: Icon(Icons.home, size: 24.sp)),
        LabelIcons(
          label: '热点',
          icon: Icon(Icons.local_fire_department, size: 24.sp),
        ),
        LabelIcons(label: '体系', icon: Icon(Icons.timeline, size: 24.sp)),
        LabelIcons(label: '我的', icon: Icon(Icons.person, size: 24.sp)),
      ],
    );
  }
}
