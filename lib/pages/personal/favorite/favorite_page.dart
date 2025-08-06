
import 'package:example/pages/personal/favorite/fvavorite_vm.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/loading.dart';
import '../../../components/postItem.dart';
import '../../../routes/route_utils.dart';
import '../../../routes/routes.dart';
import '../../login/login_vm.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() {
    return _FavoritePageState();
  }
}

class _FavoritePageState extends State<FavoritePage> {

  var vm = new FavoriteViewModel();
  RefreshController _refreshController = RefreshController(
      initialRefresh: false);
  int _page = 1;

  void _onRefresh() async {
    _page = 1;
    // monitor network fetch
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
  void didChangeDependencies() async {
    Loading.showLoading();
    try {
      await vm.getListData(_page);
    } catch (e) {

    }
    Loading.dismissAll();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoriteViewModel>(
        create: (context) {
      return vm;
    },
    child: Scaffold(
      appBar: AppBar(title: Text("我的收藏"),),
      body: SafeArea(child: SmartRefresher(
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
              Consumer<FavoriteViewModel>(
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

                            await vm.delCollectPost(item.id.toString());
                            showToast("取消成功");
                            vm.updateListData(index);

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
        ),)),
    ));
  }
}