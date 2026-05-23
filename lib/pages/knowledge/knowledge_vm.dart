import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/request/request.dart';
import 'knowledge_menu_tree_model_entity.dart';

final knowledgeProvider =
    AsyncNotifierProvider<KnowledgeNotifier, KnowledgePageState>(
      KnowledgeNotifier.new,
    );

class KnowledgePageState {
  const KnowledgePageState({this.menuTreeData = const []});

  final List<KnowledgeMenuTreeModelEntity> menuTreeData;

  KnowledgePageState copyWith({
    List<KnowledgeMenuTreeModelEntity>? menuTreeData,
  }) {
    return KnowledgePageState(menuTreeData: menuTreeData ?? this.menuTreeData);
  }
}

class KnowledgeNotifier extends AsyncNotifier<KnowledgePageState> {
  @override
  Future<KnowledgePageState> build() async {
    return _loadMenuTree();
  }

  Future<KnowledgePageState> refresh() async {
    final next = await _loadMenuTree(previous: state.asData?.value);
    state = AsyncData(next);
    return next;
  }

  Future<KnowledgePageState> _loadMenuTree({KnowledgePageState? previous}) async {
    final current = previous ?? const KnowledgePageState();
    try {
      final res = await Request.get<List<KnowledgeMenuTreeModelEntity>>(
        '/tree/json',
      );
      return current.copyWith(menuTreeData: res.data ?? current.menuTreeData);
    } catch (_) {
      return current;
    }
  }
}
