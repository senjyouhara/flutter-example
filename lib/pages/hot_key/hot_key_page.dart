import 'dart:developer';

import 'package:example/pages/hot_key/hot_key_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../routes/route_utils.dart';
import '../../routes/routes.dart';

class HotKeyPage extends StatefulWidget {
  const HotKeyPage({super.key});

  @override
  State<HotKeyPage> createState() {
    return _HotKeyPageState();
  }
}

class _HotKeyPageState extends State<HotKeyPage> {
  HotKeyViewModel vm = HotKeyViewModel();

  @override
  void initState() {
    super.initState();
    vm.getFriendData();
    vm.getHotKeyData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HotKeyViewModel>(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [_searchBar(), _hotkeyGrid(), _friendGrid()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0x66000000), width: 1.w),
        ), // 边色与边宽度
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Text(
                "搜索热词",
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
            ),
            GestureDetector(
              child: Icon(Icons.search, size: 24, color: Colors.black),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _friendGrid() {
    return Consumer<HotKeyViewModel>(
      builder: (context, vm, child) {
        return Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 10.w, left: 10.w),
              child: Text(
                "常用网站",
                style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            gridList(vm.friendData.map((item)=> item.name ?? "").toList(), onTap: (name, index){
              var link = vm.friendData[index].link;
              RouteUtils.pushNamed(
                context,
                RoutesPath.webviewPage,
                arguments: {"title": name, "url": link},
              );
            }),
          ],
        );
      },
    );
  }

  Widget _hotkeyGrid() {
    return Consumer<HotKeyViewModel>(
      builder: (context, vm, child) {
        return gridList(vm.hotKeyData.map((item)=> item.name ?? "").toList(), onTap: (name, index){
          RouteUtils.pushNamed(
            context,
            RoutesPath.searchPage,
            arguments: {"title": name},
          );
        });
      },
    );
  }

  Widget gridList(List<String> list, {void Function(String, int)? onTap}){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisSpacing: 10.r,
        crossAxisSpacing: 10.r,
        maxCrossAxisExtent: 120.w,
        childAspectRatio: 1.7.r,
      ),
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            border: Border.all(color: Colors.grey),
          ),
          child: GestureDetector(
            onTap: (){
              onTap?.call(list[index], index);
            },
            child: Text(list[index] ?? ""),
          ),
        );
      },
      padding: EdgeInsets.all(10.w),
      itemCount: list.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
