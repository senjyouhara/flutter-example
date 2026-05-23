import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/request/request.dart';
import '../../home/home_list_model_entity.dart';

final favoriteProvider =
    AsyncNotifierProvider.autoDispose<FavoriteNotifier, FavoritePageState>(
      FavoriteNotifier.new,
    );

class FavoritePageState {
  const FavoritePageState({
    this.listData = const [],
    this.pageTotal = 0,
    this.isPageEnd = false,
    this.page = 1,
  });

  final List<HomeListModelDatas> listData;
  final int pageTotal;
  final bool isPageEnd;
  final int page;

  FavoritePageState copyWith({
    List<HomeListModelDatas>? listData,
    int? pageTotal,
    bool? isPageEnd,
    int? page,
  }) {
    return FavoritePageState(
      listData: listData ?? this.listData,
      pageTotal: pageTotal ?? this.pageTotal,
      isPageEnd: isPageEnd ?? this.isPageEnd,
      page: page ?? this.page,
    );
  }
}

class FavoriteNotifier extends AsyncNotifier<FavoritePageState> {
  @override
  Future<FavoritePageState> build() async {
    return const FavoritePageState();
  }

  Future<FavoritePageState> refresh() async {
    final current = state.asData?.value ?? const FavoritePageState();
    final next = await _loadPage(current: current, page: 1, replaceList: true);
    state = AsyncData(next);
    return next;
  }

  Future<FavoritePageState> loadNextPage() async {
    final current = state.asData?.value;
    if (current == null || current.isPageEnd) {
      return current ?? const FavoritePageState();
    }
    final next = await _loadPage(
      current: current,
      page: current.page + 1,
      replaceList: false,
    );
    state = AsyncData(next);
    return next;
  }

  Future<void> delCollectPost(String id) async {
    await Request.post('/lg/uncollect_originId/$id/json');
  }

  Future<void> removeAt(int index) async {
    final current = state.asData?.value;
    if (current == null || index < 0 || index >= current.listData.length) {
      return;
    }
    final nextList = [...current.listData]..removeAt(index);
    state = AsyncData(current.copyWith(listData: nextList));
  }

  Future<FavoritePageState> _loadPage({
    required FavoritePageState current,
    required int page,
    required bool replaceList,
  }) async {
    try {
      final res = await Request.get<HomeListModelEntity>(
        '/lg/collect/list/${page - 1}/json',
      );
      final fetchedList = res.data?.datas ?? const <HomeListModelDatas>[];
      for (final item in fetchedList) {
        item.collect = true;
      }
      final listData = replaceList ? fetchedList : [...current.listData, ...fetchedList];
      final curPage = res.data?.curPage ?? page;
      final pageCount = res.data?.pageCount ?? curPage;
      return current.copyWith(
        listData: listData,
        pageTotal: res.data?.total ?? current.pageTotal,
        isPageEnd: pageCount <= curPage,
        page: curPage,
      );
    } catch (_) {
      return current.copyWith(page: page);
    }
  }
}
