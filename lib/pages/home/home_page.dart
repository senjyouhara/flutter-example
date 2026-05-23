import 'package:example/pages/home/home_model_entity.dart';
import 'package:example/pages/home/home_vm.dart';
import 'package:example/pages/login/login_vm.dart';
import 'package:example/routes/route_utils.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../components/loading.dart';
import '../../components/post_item.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshController = useMemoized(
      () => RefreshController(initialRefresh: false),
    );
    useEffect(() {
      return refreshController.dispose;
    }, [refreshController]);

    final homeAsync = ref.watch(homeProvider);
    final homeState = homeAsync.asData?.value;
    final notifier = ref.read(homeProvider.notifier);

    useEffect(() {
      Loading.showLoading();
      return () {
        Loading.dismissAll();
      };
    }, const []);

    useEffect(() {
      if (!homeAsync.isLoading) {
        Loading.dismissAll();
      }
      return null;
    }, [homeAsync.isLoading]);

    if (homeState == null) {
      return const Scaffold(
        body: SafeArea(
          child: SizedBox.expand(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: () async {
            refreshController.resetNoData();
            final next = await notifier.refresh();
            refreshController.refreshCompleted();
            if (next.isPageEnd) {
              refreshController.loadNoData();
            }
          },
          onLoading: () async {
            final next = await notifier.loadNextPage();
            if (next.isPageEnd) {
              refreshController.loadNoData();
            } else {
              refreshController.loadComplete();
            }
          },
          header: MaterialClassicHeader(),
          footer: ClassicFooter(
            loadingText: '正在加载中',
            failedText: '加载失败请重试',
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _swiper(homeState.bannerData),
                ListView.builder(
                  itemCount: homeState.listData.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = homeState.listData[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: PostItemWidget(
                          data: item,
                          index: index,
                          onFavoriteTap: (item) async {
                            if (!ref.read(authProvider).isLoggedIn) {
                              return;
                            }
                            final collected = await notifier.toggleFavorite(item);
                            if (collected) {
                              showToast('收藏成功！');
                            }
                          },
                        ),
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

  Widget _swiper(List<HomeModelEntity> bannerData) {
    return SizedBox(
      height: 150.h,
      child: Swiper(
        outer: false,
        autoplayDelay: 5000,
        itemCount: bannerData.length,
        autoplay: true,
        loop: true,
        indicatorLayout: PageIndicatorLayout.NONE,
        itemBuilder: (context, index) {
          return SizedBox(
            width: double.infinity,
            child: Image.network(
              bannerData[index].imagePath ?? '',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
