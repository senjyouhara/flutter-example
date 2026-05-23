import 'package:example/pages/hot_key/friend_model_entity.dart';
import 'package:example/pages/hot_key/hot_key_model_entity.dart';
import 'package:example/pages/hot_key/hot_key_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/loading.dart';
import '../../routes/route_utils.dart';
import '../../routes/routes.dart';

class HotKeyPage extends HookConsumerWidget {
  const HotKeyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotKeyAsync = ref.watch(hotKeyProvider);
    final hotKeyState = hotKeyAsync.asData?.value;

    useEffect(() {
      Loading.showLoading();
      return () {
        Loading.dismissAll();
      };
    }, const []);

    useEffect(() {
      if (!hotKeyAsync.isLoading) {
        Loading.dismissAll();
      }
      return null;
    }, [hotKeyAsync.isLoading]);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _searchBar(context),
              _hotkeyGrid(context, hotKeyState?.hotKeyData ?? const []),
              _friendGrid(context, hotKeyState?.friendData ?? const []),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0x66000000), width: 1.w),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '搜索热词',
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
            ),
            GestureDetector(
              onTap: () {
                RouteUtils.pushNamed(
                  context,
                  RoutesPath.searchPage,
                );
              },
              child: const Icon(Icons.search, size: 24, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _friendGrid(BuildContext context, List<FriendModelEntity> items) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10.w, left: 10.w),
          child: Text(
            '常用网站',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        gridList(
          items.map((item) => item.name ?? '').toList(),
          onTap: (name, index) {
            final link = items[index].link;
            RouteUtils.pushNamed(
              context,
              RoutesPath.webviewPageLocation(title: name, url: link),
            );
          },
        ),
      ],
    );
  }

  Widget _hotkeyGrid(BuildContext context, List<HotKeyModelEntity> items) {
    return gridList(
      items.map((item) => item.name ?? '').toList(),
      onTap: (name, index) {
        RouteUtils.pushNamed(
          context,
          RoutesPath.searchPageLocation(keyword: name),
        );
      },
    );
  }

  Widget gridList(List<String> list, {void Function(String, int)? onTap}) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisSpacing: 10.r,
        crossAxisSpacing: 10.r,
        maxCrossAxisExtent: 120.w,
        childAspectRatio: 1.7.r,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onTap?.call(list[index], index);
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(list[index]),
          ),
        );
      },
      padding: EdgeInsets.all(10.w),
      itemCount: list.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
