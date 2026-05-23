import 'package:example/pages/home/home_list_model_entity.dart';
import 'package:example/pages/home/home_model_entity.dart';
import 'package:example/utils/request/request.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeProvider =
    AsyncNotifierProvider<HomeNotifier, HomePageState>(HomeNotifier.new);

class HomePageState {
  const HomePageState({
    this.bannerData = const [],
    this.listData = const [],
    this.page = 1,
    this.pageTotal = 0,
    this.isPageEnd = false,
  });

  final List<HomeModelEntity> bannerData;
  final List<HomeListModelDatas> listData;
  final int page;
  final int pageTotal;
  final bool isPageEnd;

  HomePageState copyWith({
    List<HomeModelEntity>? bannerData,
    List<HomeListModelDatas>? listData,
    int? page,
    int? pageTotal,
    bool? isPageEnd,
  }) {
    return HomePageState(
      bannerData: bannerData ?? this.bannerData,
      listData: listData ?? this.listData,
      page: page ?? this.page,
      pageTotal: pageTotal ?? this.pageTotal,
      isPageEnd: isPageEnd ?? this.isPageEnd,
    );
  }
}

class HomeNotifier extends AsyncNotifier<HomePageState> {
  @override
  Future<HomePageState> build() async {
    return _loadFirstPage();
  }

  Future<HomePageState> refresh() async {
    final next = await _loadFirstPage(previous: state.asData?.value);
    state = AsyncData(next);
    return next;
  }

  Future<HomePageState> loadNextPage() async {
    final current = state.asData?.value;
    if (current == null || current.isPageEnd) {
      return current ?? const HomePageState();
    }

    final next = await _loadNextPage(current);
    state = AsyncData(next);
    return next;
  }

  Future<bool> toggleFavorite(HomeListModelDatas item) async {
    final current = state.asData?.value;
    if (current == null) {
      return item.collect ?? false;
    }

    final index = current.listData.indexWhere((element) => element.id == item.id);
    if (index == -1) {
      return item.collect ?? false;
    }

    final nextItem = _cloneItem(current.listData[index]);
    if (nextItem.collect == false) {
      await Request.post('/lg/collect/${nextItem.id}/json');
      nextItem.collect = true;
    } else {
      await Request.post('/lg/uncollect_originId/${nextItem.id}/json');
      nextItem.collect = false;
    }

    final nextList = [...current.listData];
    nextList[index] = nextItem;
    state = AsyncData(current.copyWith(listData: nextList));
    return nextItem.collect ?? false;
  }

  Future<HomePageState> _loadFirstPage({HomePageState? previous}) async {
    final current = previous ?? const HomePageState();
    final bannerData = await _loadBanner(current.bannerData);
    final initial = current.copyWith(
      bannerData: bannerData,
      page: 1,
    );
    return _loadListPage(
      current: initial,
      page: 1,
      replaceList: true,
    );
  }

  Future<HomePageState> _loadNextPage(HomePageState current) async {
    final nextPage = current.page + 1;
    return _loadListPage(
      current: current,
      page: nextPage,
      replaceList: false,
    );
  }

  Future<List<HomeModelEntity>> _loadBanner(
    List<HomeModelEntity> fallback,
  ) async {
    try {
      final res = await Request.get<List<HomeModelEntity>>('/banner/json');
      return res.data ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  Future<HomePageState> _loadListPage({
    required HomePageState current,
    required int page,
    required bool replaceList,
  }) async {
    try {
      final res = await Request.get<HomeListModelEntity>(
        '/article/list/${page - 1}/json',
      );
      final fetchedList = res.data?.datas ?? const <HomeListModelDatas>[];
      final listData = replaceList
          ? fetchedList
          : [...current.listData, ...fetchedList];
      final curPage = res.data?.curPage ?? page;
      final pageCount = res.data?.pageCount ?? curPage;
      return current.copyWith(
        listData: listData,
        page: curPage,
        pageTotal: res.data?.total ?? current.pageTotal,
        isPageEnd: pageCount <= curPage,
      );
    } catch (_) {
      return current.copyWith(page: page);
    }
  }

  HomeListModelDatas _cloneItem(HomeListModelDatas item) {
    return HomeListModelDatas.fromJson(item.toJson());
  }
}
