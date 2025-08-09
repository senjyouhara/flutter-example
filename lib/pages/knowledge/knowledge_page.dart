import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/loading.dart';
import '../../routes/route_utils.dart';
import '../../routes/routes.dart';
import 'knowledge_vm.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<KnowledgePage> createState() {
    return _KnowledgePageState();
  }
}

class _KnowledgePageState extends State<KnowledgePage> {
  final vm = KnowledgeViewModel();
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Loading.showLoading();
      try {
        await vm.getMenuTree();
      } catch (e) {}
      Loading.dismissAll();
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    await vm.getMenuTree();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<KnowledgeViewModel>(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        body: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: _onRefresh,
            header: MaterialClassicHeader(),
            child: SingleChildScrollView(
              child: Consumer<KnowledgeViewModel>(builder: (context, vm, children){
                return Column(
                  children: [
                    ListView.builder(
                      itemCount: vm.menuTreeData.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var item = vm.menuTreeData[index];
                        return Container(
                          padding: EdgeInsets.all(12),
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color(0xffcccccc), // 边框颜色
                                  width: 1.r, // 边框宽度
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(12),
                              width: double.infinity,
                              child: Row(
                                spacing: 12.r,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Column(
                                    spacing: 8.r,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? "",
                                        style: TextStyle(
                                          fontSize: 17.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Wrap(
                                        spacing: 4.0, // 主轴方向上的间距
                                        runSpacing: 2.0, // 交叉轴方向上的间距
                                        children: ([
                                          if (item.children != null &&
                                              item.children!.length > 0)
                                            for (var child in item.children!)
                                              Padding(
                                                padding: EdgeInsets.all(0.r),
                                                child: Text(
                                                  child.name ?? "",
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                        ]),
                                      )
                                    ],
                                  ),),
                                  Icon(Icons.chevron_right, size: 21),
                                ],
                              ),
                            ),
                            behavior: HitTestBehavior.translucent,
                            // 或 .translucent
                            onTap: () {
                              print("路由跳转");
                              RouteUtils.pushNamed(
                                context,
                                RoutesPath.knowledgeDetailPage,
                                arguments: {
                                  "id": vm.menuTreeData[index].id,
                                  "cid": vm.menuTreeData[index].children![0].id,
                                  "title": vm.menuTreeData[index].name,
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
