import 'package:example/pages/home/home_page.dart';
import 'package:example/pages/hot_key/hot_key_page.dart';
import 'package:example/pages/knowledge/person_page.dart';
import 'package:example/pages/personal/person_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/navigation_bar/navigation_bar_widget.dart';

class TabbarPage extends StatefulWidget {
  const TabbarPage({super.key});

  @override
  State<TabbarPage> createState() {
    return _TabbarPageState();
  }
}

class _TabbarPageState extends State<TabbarPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      pages: [HomePage(), HotKeyPage(), KnowledgePage(), PersonalPage()],
      labels: [
        LabelIcons(
          label: "首页",
          icon: Icon(Icons.home, size: 24.sp),
        ),
        LabelIcons(
          label: "热点",
          icon: Icon(Icons.local_fire_department, size: 24.sp),
        ),
        LabelIcons(
          label: "体系",
          icon: Icon(Icons.timeline, size: 24.sp),
        ),
        LabelIcons(
          label: "我的",
          icon: Icon(Icons.person, size: 24.sp),
        ),
      ],
    );
  }
}
