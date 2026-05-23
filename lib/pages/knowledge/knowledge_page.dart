import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/loading.dart';
import '../../routes/route_utils.dart';
import '../../routes/routes.dart';
import 'knowledge_vm.dart';

class KnowledgePage extends HookConsumerWidget {
  const KnowledgePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshController = useMemoized(
      () => RefreshController(initialRefresh: false),
    );
    final knowledgeAsync = ref.watch(knowledgeProvider);
    final knowledgeState = knowledgeAsync.asData?.value;

    useEffect(() {
      Loading.showLoading();
      return () {
        refreshController.dispose();
        Loading.dismissAll();
      };
    }, [refreshController]);

    useEffect(() {
      if (!knowledgeAsync.isLoading) {
        Loading.dismissAll();
      }
      return null;
    }, [knowledgeAsync.isLoading]);

    Future<void> onRefresh() async {
      await ref.read(knowledgeProvider.notifier).refresh();
      refreshController.refreshCompleted();
    }

    final menuTreeData = knowledgeState?.menuTreeData ?? const [];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: onRefresh,
          header: const MaterialClassicHeader(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  itemCount: menuTreeData.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = menuTreeData[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          final children = item.children ?? const [];
                          if (children.isEmpty) {
                            showToast('暂无可查看的分类');
                            return;
                          }

                          RouteUtils.pushNamed(
                            context,
                            RoutesPath.knowledgeDetailPage,
                            arguments: {
                              'id': item.id,
                              'cid': children.first.id,
                              'title': item.name,
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xffcccccc),
                              width: 1.r,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(12),
                          width: double.infinity,
                          child: Row(
                            spacing: 12.r,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: 8.r,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name ?? '',
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 4.0,
                                      runSpacing: 2.0,
                                      children: [
                                        if (item.children != null &&
                                            item.children!.isNotEmpty)
                                          for (final child in item.children!)
                                            Padding(
                                              padding: EdgeInsets.all(0.r),
                                              child: Text(
                                                child.name ?? '',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, size: 21),
                            ],
                          ),
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
    );
  }
}
