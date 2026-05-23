import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/loading.dart';
import '../../../routes/route_utils.dart';
import '../../../routes/routes.dart';
import '../knowledge_menu_tree_model_entity.dart';
import 'knowledge_detail_vm.dart';

class KnowledgeDetailPage extends HookConsumerWidget {
  const KnowledgeDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshController = useMemoized(
      () => RefreshController(initialRefresh: false),
    );
    final title = useState<String?>(null);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final map = ModalRoute.of(context)?.settings.arguments;
        if (map is! Map) {
          return;
        }

        title.value = map['title']?.toString();
        final pid = map['id'];
        final cid = map['cid'];
        if (cid?.toString().isNotEmpty == true && pid != null && cid != null) {
          Loading.showLoading();
          await ref.read(knowledgeDetailProvider.notifier).initialize(
                pid: pid as int,
                cid: cid as int,
              );
          Loading.dismissAll();
        } else {
          showToast('参数有误！');
        }
      });
      return refreshController.dispose;
    }, const []);

    Future<void> onRefresh() async {
      final next = await ref.read(knowledgeDetailProvider.notifier).refresh();
      refreshController.refreshCompleted();
      if (next.isPageEnd) {
        refreshController.loadNoData();
      } else {
        refreshController.resetNoData();
      }
    }

    Future<void> onLoading() async {
      final next = await ref.read(knowledgeDetailProvider.notifier).loadNextPage();
      if (next.isPageEnd) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }

    final detailState = ref.watch(knowledgeDetailProvider).asData?.value;
    final selectedPid = detailState?.selectedPid;
    final selectedCid = detailState?.selectedCid;
    final menuItems = _resolveMenuItems(
      detailState?.menuTreeData ?? const [],
      selectedPid,
    );
    final listData = detailState?.listData ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(title.value ?? '')),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: menuItems.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        Loading.showLoading();
                        await ref
                            .read(knowledgeDetailProvider.notifier)
                            .selectCategory(item.id!);
                        Loading.dismissAll();
                        refreshController.resetNoData();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(0.r),
                            child: Text(
                              item.name ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: selectedCid == item.id
                                    ? Colors.blueAccent
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SmartRefresher(
                controller: refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: onRefresh,
                onLoading: onLoading,
                header: const MaterialClassicHeader(),
                footer: const ClassicFooter(
                  loadingText: '正在加载中',
                  failedText: '加载失败请重试',
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: listData.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = listData[index];
                          return GestureDetector(
                            onTap: () {
                              RouteUtils.pushNamed(
                                context,
                                RoutesPath.webviewPage,
                                arguments: {
                                  'title': item.title?.replaceAll(
                                    RegExp(r'<[^>]*>'),
                                    '',
                                  ),
                                  'url': item.link,
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: listData.length - 1 == index
                                    ? null
                                    : Border(
                                        bottom: BorderSide(
                                          color: const Color(0x66000000),
                                          width: 1.w,
                                        ),
                                      ),
                              ),
                              padding: EdgeInsets.fromLTRB(6.w, 10.w, 6.w, 10.w),
                              child: Html(
                                data: item.title ?? '',
                                style: {
                                  'html': Style(fontSize: FontSize(16.sp)),
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<KnowledgeMenuTreeModelEntity> _resolveMenuItems(
    List<KnowledgeMenuTreeModelEntity> menuTreeData,
    int? selectedPid,
  ) {
    if (menuTreeData.isEmpty) {
      return const [];
    }
    final index = menuTreeData.indexWhere((item) => item.id == selectedPid);
    if (index <= 0) {
      return menuTreeData.first.children ?? const [];
    }
    return menuTreeData[index].children ?? const [];
  }
}
