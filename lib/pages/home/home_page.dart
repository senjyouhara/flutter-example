import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/extensions/image_extension.dart';
import 'package:example/pages/login/login_vm.dart';
import 'package:example/pages/webview/webview_page.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../../components/loading.dart';
import '../../components/postItem.dart';
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
  RefreshController _refreshController = RefreshController(
      initialRefresh: false);
  int _page = 1;

  @override
  void didChangeDependencies() {
   init();
  }

  void init() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      Loading.showLoading();
    });
    try {
      await vm.getBanner();
    } catch (e) {

    }

    try {
      await vm.getListData(_page);
    } catch (e) {

    }
    Loading.dismissAll();

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
    if (mounted)
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
              footer: ClassicFooter(
                  loadingText: "正在加载中", failedText: "加载失败请重试"),
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
                                child: PostItemWidget(data: vm.listData[index], index: index, onFavoriteTap: (item)async {

                                  if(context.read<LoginViewModel>().userInfo == null){
                                    return;
                                  }

                                  if(item.collect == false){
                                    await vm.collectInnerPost(item.id.toString());
                                    showToast("收藏成功！");
                                    item.collect = true;
                                  } else {
                                    await vm.delCollectPost(item.id.toString());
                                    item.collect = false;
                                  }
                                  vm.updateListData(item, index);
                                }),
                                behavior: HitTestBehavior.translucent,
                                // 或 .translucent
                                onTap: () {
                                  print("路由跳转");
                                  RouteUtils.pushNamed(
                                    context,
                                    RoutesPath.webviewPage,
                                    arguments: {
                                      "title": vm.listData[index].title
                                    },
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
}
