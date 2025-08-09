import 'package:example/pages/home/home_page.dart';
import 'package:example/pages/hot_key/hot_key_page.dart';
import 'package:example/pages/knowledge/knowledge_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      pages: [
        LabelIcons(
          page: const HomePage(),
          label: "首页",
          icon: Icon(Icons.home, size: 24.sp),
        ),
        LabelIcons(
          page: const HotKeyPage(),
          label: "热点",
          icon: Icon(Icons.local_fire_department, size: 24.sp),
        ),
        LabelIcons(
          page: const KnowledgePage(),
          label: "体系",
          icon: Icon(Icons.timeline, size: 24.sp),
        ),
        LabelIcons(
          page: const PersonalPage(),
          label: "我的",
          icon: Icon(Icons.person, size: 24.sp),
        ),
      ],
    );
  }

}
