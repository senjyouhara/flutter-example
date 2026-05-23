import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/request/request.dart';
import '../knowledge_menu_tree_model_entity.dart';
import '../knowledge_model_entity.dart';

final knowledgeDetailProvider = AsyncNotifierProvider.autoDispose<
  KnowledgeDetailNotifier,
  KnowledgeDetailPageState
>(KnowledgeDetailNotifier.new);

class KnowledgeDetailPageState {
  const KnowledgeDetailPageState({
    this.listData = const [],
    this.menuTreeData = const [],
    this.pageTotal = 0,
    this.isPageEnd = false,
    this.selectedCid,
    this.selectedPid,
    this.page = 1,
  });

  final List<KnowledgeModelDatas> listData;
  final List<KnowledgeMenuTreeModelEntity> menuTreeData;
  final int pageTotal;
  final bool isPageEnd;
  final int? selectedCid;
  final int? selectedPid;
  final int page;

  KnowledgeDetailPageState copyWith({
    List<KnowledgeModelDatas>? listData,
    List<KnowledgeMenuTreeModelEntity>? menuTreeData,
    int? pageTotal,
    bool? isPageEnd,
    int? selectedCid,
    bool clearSelectedCid = false,
    int? selectedPid,
    bool clearSelectedPid = false,
    int? page,
  }) {
    return KnowledgeDetailPageState(
      listData: listData ?? this.listData,
      menuTreeData: menuTreeData ?? this.menuTreeData,
      pageTotal: pageTotal ?? this.pageTotal,
      isPageEnd: isPageEnd ?? this.isPageEnd,
      selectedCid: clearSelectedCid ? null : (selectedCid ?? this.selectedCid),
      selectedPid: clearSelectedPid ? null : (selectedPid ?? this.selectedPid),
      page: page ?? this.page,
    );
  }
}

class KnowledgeDetailNotifier extends AsyncNotifier<KnowledgeDetailPageState> {
  @override
  Future<KnowledgeDetailPageState> build() async {
    return const KnowledgeDetailPageState();
  }

  Future<KnowledgeDetailPageState> initialize({
    required int pid,
    required int cid,
  }) async {
    final current = (state.asData?.value ?? const KnowledgeDetailPageState())
        .copyWith(selectedPid: pid, selectedCid: cid, page: 1);
    final next = await _loadInitial(current);
    state = AsyncData(next);
    return next;
  }

  Future<KnowledgeDetailPageState> selectCategory(int cid) async {
    final current = state.asData?.value;
    if (current == null) {
      return const KnowledgeDetailPageState();
    }
    final next = await _loadListPage(
      current: current.copyWith(selectedCid: cid),
      page: 1,
      replaceList: true,
    );
    state = AsyncData(next);
    return next;
  }

  Future<KnowledgeDetailPageState> refresh() async {
    final current = state.asData?.value;
    if (current == null || current.selectedCid == null) {
      return current ?? const KnowledgeDetailPageState();
    }
    final next = await _loadListPage(
      current: current,
      page: 1,
      replaceList: true,
    );
    state = AsyncData(next);
    return next;
  }

  Future<KnowledgeDetailPageState> loadNextPage() async {
    final current = state.asData?.value;
    if (current == null || current.isPageEnd || current.selectedCid == null) {
      return current ?? const KnowledgeDetailPageState();
    }
    final next = await _loadListPage(
      current: current,
      page: current.page + 1,
      replaceList: false,
    );
    state = AsyncData(next);
    return next;
  }

  Future<KnowledgeDetailPageState> _loadInitial(
    KnowledgeDetailPageState current,
  ) async {
    var next = current;
    try {
      final menuRes = await Request.get<List<KnowledgeMenuTreeModelEntity>>(
        '/tree/json',
      );
      next = next.copyWith(menuTreeData: menuRes.data ?? next.menuTreeData);
    } catch (_) {}

    return _loadListPage(current: next, page: 1, replaceList: true);
  }

  Future<KnowledgeDetailPageState> _loadListPage({
    required KnowledgeDetailPageState current,
    required int page,
    required bool replaceList,
  }) async {
    final cid = current.selectedCid;
    if (cid == null) {
      return current;
    }

    try {
      final res = await Request.get<KnowledgeModelEntity>(
        '/article/list/${page - 1}/json?&cid=$cid',
      );
      final fetchedList = res.data?.datas ?? const <KnowledgeModelDatas>[];
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
