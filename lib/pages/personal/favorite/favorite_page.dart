import 'package:example/pages/personal/favorite/favorite_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/loading.dart';
import '../../../components/post_item.dart';
import '../../../routes/route_utils.dart';
import '../../../routes/routes.dart';
import '../../login/login_vm.dart';

class FavoritePage extends HookConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshController = useMemoized(
      () => RefreshController(initialRefresh: false),
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Loading.showLoading();
        await ref.read(favoriteProvider.notifier).refresh();
        Loading.dismissAll();
      });
      return refreshController.dispose;
    }, const []);

    Future<void> onRefresh() async {
      final next = await ref.read(favoriteProvider.notifier).refresh();
      refreshController.refreshCompleted();
      if (next.isPageEnd) {
        refreshController.loadNoData();
      } else {
        refreshController.resetNoData();
      }
    }

    Future<void> onLoading() async {
      final next = await ref.read(favoriteProvider.notifier).loadNextPage();
      if (next.isPageEnd) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }

    final favoriteState = ref.watch(favoriteProvider).asData?.value;
    final listData = favoriteState?.listData ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: SafeArea(
        bottom: false,
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
                    return Container(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          RouteUtils.pushNamed(
                            context,
                            RoutesPath.webviewPage,
                            arguments: {
                              'title': item.title,
                              'url': item.link,
                            },
                          );
                        },
                        child: PostItemWidget(
                          data: item,
                          index: index,
                          onFavoriteTap: (item) async {
                            if (!ref.read(authProvider).isLoggedIn) {
                              return;
                            }

                            await ref
                                .read(favoriteProvider.notifier)
                                .delCollectPost(item.id.toString());
                            showToast('取消成功');
                            await ref
                                .read(favoriteProvider.notifier)
                                .removeAt(index);
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
    );
  }
}
