

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabelIcons {

  String? label;
  Widget? icon;
  Widget? page;

  LabelIcons({
    String? label,
    Widget? icon,
    Widget? page
}){
    this.label = label;
    this.icon = icon;
    this.page = page;
  }

}

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key,
    required this.pages,
    this.onTabChanged,
  });

  final List<LabelIcons> pages;

  final ValueChanged<int>? onTabChanged;

  @override
  State<NavigationBarWidget> createState() {
    return _NavigationBarWidgetState();
  }
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {

  int index = 0;

  @override
  void didChangeDependencies() {
    var map = ModalRoute.of(context)?.settings?.arguments;
    if(map is Map){
      this.index = map["index"];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: index,
          children: widget.pages.map((item){
            return item.page!;
          }).toList(),
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          // 去掉水波纹效果
          // splashColor: Colors.transparent,
          // 去掉长按效果
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          // 设置文字大小
          selectedFontSize: 14,
          unselectedFontSize: 14,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black45,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items:  widget.pages.map((item) => BottomNavigationBarItem(
            label: item.label,
            icon: item.icon!,
            tooltip: '',
          )).toList(),
          // [
          //   BottomNavigationBarItem(
          //     label: "首页",
          //     icon: Icon(Icons.home, size: 24.sp),
          //     tooltip: '',
          //   ),
          //   BottomNavigationBarItem(
          //     label: "热点",
          //     icon: Icon(Icons.local_fire_department, size: 24.sp),
          //     tooltip: '',
          //   ),
          //   BottomNavigationBarItem(
          //     label: "体系",
          //     icon: Icon(Icons.timeline, size: 24.sp),
          //     tooltip: '',
          //   ),
          //   BottomNavigationBarItem(
          //     label: "我的",
          //     icon: Icon(Icons.person, size: 24.sp),
          //     tooltip: '',
          //   ),
          // ],
          onTap: (index) {
            this.index = index;
            widget.onTabChanged?.call(index);
            setState(() {});
          },
        ),
      ),
    );
  }
}