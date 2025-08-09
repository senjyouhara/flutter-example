import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/loading.dart';
import '../../../routes/route_utils.dart';
import '../../../routes/routes.dart';
import 'knowledge_detail_vm.dart';

class KnowledgeDetailPage extends StatefulWidget {
  const KnowledgeDetailPage({super.key});

  @override
  State<KnowledgeDetailPage> createState() {
    return _KnowledgeDetailPageState();
  }
}

class _KnowledgeDetailPageState extends State<KnowledgeDetailPage> {
  final vm = KnowledgeDetailViewModel();
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  int _page = 1;
  String? title;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var map = ModalRoute.of(context)?.settings?.arguments;
      if (map is Map) {
        title = map["title"];
        if (map["cid"]?.toString().isNotEmpty == true) {
          vm.pid = map["id"];
          vm.id = map["cid"];
          Loading.showLoading();
          await vm.getListData(_page, cid: vm.id);
        } else {
          showToast("参数有误！");
        }
        setState(() {});
      }
      await vm.getMenuTree();
      Loading.dismissAll();
    });
  }

  void _onRefresh() async {
    _page = 1;
    // monitor network fetch
    await vm.getListData(_page, cid: vm.id);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _page++;
    // monitor network fetch
    await vm.getListData(_page, cid: vm.id);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<KnowledgeDetailViewModel>(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title ?? "")),
        body: SafeArea(
          child: Column(
            children: [
              Consumer<KnowledgeDetailViewModel>(
                builder: (context, vm, child) {
                  var index = vm.menuTreeData.indexWhere(
                    (item) => item.id == vm.pid!,
                  );
                  var items = vm.menuTreeData.length <= 0
                      ? []
                      : index <= 0
                      ? vm.menuTreeData[0]?.children ?? []
                      : vm.menuTreeData[index]?.children ?? [];
                  return Container(
                    height: 40.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(12),
                          child: GestureDetector(
                            child: Container(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(0.r),
                                    child: Text(
                                      items[index].name ?? "",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: vm.id == items[index].id
                                            ? Colors.blueAccent
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            behavior: HitTestBehavior.translucent,
                            // 或 .translucent
                            onTap: () async {
                              vm.id = items[index].id;
                              _page = 1;
                              Loading.showLoading();
                              try {
                                await vm.getListData(_page, cid: vm.id);
                              } catch (e){

                              }
                              Loading.dismissAll();
                              // monitor network fetch
                              // Navigator.push(context, MaterialPageRoute(builder: (c) => WebviewPage(title: "跳转页面标题")));
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Expanded(child:   SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                header: MaterialClassicHeader(),
                footer: ClassicFooter(
                  loadingText: "正在加载中",
                  failedText: "加载失败请重试",
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Consumer<KnowledgeDetailViewModel>(
                        builder: (context, vm, child) {
                          var items = vm.listData;
                          return Container(
                            child: ListView.builder(
                              itemCount: items.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    RouteUtils.pushNamed(
                                      context,
                                      RoutesPath.webviewPage,
                                      arguments: {"title": items[index].title?.replaceAll(RegExp(r"<[^>]*>"), ""), "url": items[index].link},
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: items.length - 1 == index ? null : Border(
                                        bottom: BorderSide(color: Color(0x66000000), width: 1.w),
                                      ),
                                    ),
                                    padding: EdgeInsets.fromLTRB(6.w, 10.w, 6.w, 10.w),
                                    child: Html(data: items[index].title ?? "", style: {
                                      'html': Style(fontSize: FontSize(16.sp)),
                                    },),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuTree() {
    return Container();
  }
}
