import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/request/request.dart';
import 'search_model_entity.dart';

final searchProvider =
    AsyncNotifierProvider.autoDispose<SearchNotifier, SearchPageState>(
      SearchNotifier.new,
    );

class SearchPageState {
  const SearchPageState({
    this.searchList = const [],
    this.pageTotal = 0,
    this.isPageEnd = false,
    this.keyword = '',
    this.page = 1,
  });

  final List<SearchModelDatas> searchList;
  final int pageTotal;
  final bool isPageEnd;
  final String keyword;
  final int page;

  SearchPageState copyWith({
    List<SearchModelDatas>? searchList,
    int? pageTotal,
    bool? isPageEnd,
    String? keyword,
    int? page,
  }) {
    return SearchPageState(
      searchList: searchList ?? this.searchList,
      pageTotal: pageTotal ?? this.pageTotal,
      isPageEnd: isPageEnd ?? this.isPageEnd,
      keyword: keyword ?? this.keyword,
      page: page ?? this.page,
    );
  }
}

class SearchNotifier extends AsyncNotifier<SearchPageState> {
  @override
  Future<SearchPageState> build() async {
    return const SearchPageState();
  }

  Future<SearchPageState> search(String keyword) async {
    final current = state.asData?.value ?? const SearchPageState();
    final next = await _loadPage(
      current: current.copyWith(keyword: keyword),
      keyword: keyword,
      page: 1,
      replaceList: true,
    );
    state = AsyncData(next);
    return next;
  }

  Future<SearchPageState> refresh() async {
    final current = state.asData?.value;
    if (current == null || current.keyword.isEmpty) {
      return current ?? const SearchPageState();
    }
    final next = await _loadPage(
      current: current,
      keyword: current.keyword,
      page: 1,
      replaceList: true,
    );
    state = AsyncData(next);
    return next;
  }

  Future<SearchPageState> loadNextPage() async {
    final current = state.asData?.value;
    if (current == null || current.keyword.isEmpty || current.isPageEnd) {
      return current ?? const SearchPageState();
    }
    final next = await _loadPage(
      current: current,
      keyword: current.keyword,
      page: current.page + 1,
      replaceList: false,
    );
    state = AsyncData(next);
    return next;
  }

  Future<SearchPageState> _loadPage({
    required SearchPageState current,
    required String keyword,
    required int page,
    required bool replaceList,
  }) async {
    try {
      final result = await Request.post<SearchModelEntity>(
        '/article/query/${page - 1}/json',
        queryParameters: {'k': keyword},
      );
      final fetchedList = result.data?.datas ?? const <SearchModelDatas>[];
      final searchList = replaceList
          ? fetchedList
          : [...current.searchList, ...fetchedList];
      final curPage = result.data?.curPage ?? page;
      final pageCount = result.data?.pageCount ?? curPage;
      return current.copyWith(
        searchList: searchList,
        pageTotal: result.data?.total ?? current.pageTotal,
        isPageEnd: pageCount <= curPage,
        keyword: keyword,
        page: curPage,
      );
    } catch (_) {
      return current.copyWith(keyword: keyword, page: page);
    }
  }
}
