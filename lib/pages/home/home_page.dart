import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/extensions/image_extension.dart';
import 'package:example/pages/webview/webview_page.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../../routes/route_utils.dart';
import 'home_list_model_entity.dart';
import 'home_vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  HomeViewModel vm = new HomeViewModel();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int _page = 1;

  @override
  void initState() {
    super.initState();
    vm.getBanner();
    vm.getListData(_page);
  }

  void _onRefresh() async {
    _page = 1;
    // monitor network fetch
    await vm.getBanner();
    await vm.getListData(_page);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _page++;
    // monitor network fetch
    await vm.getListData(_page);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        body: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
          header: MaterialClassicHeader(),
          footer: ClassicFooter(loadingText: "正在加载中", failedText: "加载失败请重试"),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _swiper(),
                Consumer<HomeViewModel>(
                  builder: (context, vm, child) {
                    return ListView.builder(
                      itemCount: vm.listData.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(12),
                          child: GestureDetector(
                            child: _listItemView(vm.listData[index], index),
                            behavior: HitTestBehavior.translucent, // 或 .translucent
                            onTap: () {
                              print("路由跳转");
                              // RouteUtils.push(context, WebviewPage(title: "跳转页面标题"));
                              RouteUtils.pushNamed(
                                context,
                                RoutesPath.webviewPage,
                                arguments: {"title": vm.listData[index].title},
                              );
                              // Navigator.push(context, MaterialPageRoute(builder: (c) => WebviewPage(title: "跳转页面标题")));
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),)
        ),
      ),
    );
  }

  Widget _swiper() {
    return Consumer<HomeViewModel>(
      builder: (context, value, child) {
        return Container(
          height: 150.h,
          child: Swiper(
            outer: false,
            autoplayDelay: 5000,
            itemCount: value.bannerData.length ?? 0,
            autoplay: true,
            loop: true,
            indicatorLayout: PageIndicatorLayout.NONE,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                child: Image.network(
                  value.bannerData?[index]?.imagePath ?? "",
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _listItemView(HomeListModelDatas data, int index) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 18, 12, 18),
      // width: double.infinity,
      // height: 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xffcccccc), // 边框颜色
          width: 2.w, // 边框宽度
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  "avatar.jpg".img,
                  width: 30.w,
                  height: 30.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  (data.author?.isNotEmpty == true
                          ? data.author
                          : data.shareUser) ??
                      "",
                  style: TextStyle(fontSize: 16.sp, color: Color(0xff555555)),
                ),
              ),
              Text(
                data.niceShareDate!,
                style: TextStyle(fontSize: 16.sp, color: Color(0xff555555)),
              ),
              SizedBox(width: 12.w),
              data.type == 1
                  ? TextButton(
                      onPressed: () {
                        print("置顶");
                      },
                      child: Text(
                        "置顶",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.blueAccent,
                        ),
                      ),
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: WidgetStateProperty.all(Size(0, 0)),
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              data.title!,
              maxLines: 2,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff555555),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  data.chapterName!,
                  style: TextStyle(fontSize: 16.sp, color: Color(0xffff00ff)),
                ),
              ),
              Icon(Icons.star, size: 24.sp, color: Color(0xff999999)),
            ],
          ),
        ],
      ),
    );
  }
}
