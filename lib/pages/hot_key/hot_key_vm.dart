import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/request/request.dart';
import 'friend_model_entity.dart';
import 'hot_key_model_entity.dart';

final hotKeyProvider =
    AsyncNotifierProvider<HotKeyNotifier, HotKeyPageState>(HotKeyNotifier.new);

class HotKeyPageState {
  const HotKeyPageState({
    this.friendData = const [],
    this.hotKeyData = const [],
  });

  final List<FriendModelEntity> friendData;
  final List<HotKeyModelEntity> hotKeyData;

  HotKeyPageState copyWith({
    List<FriendModelEntity>? friendData,
    List<HotKeyModelEntity>? hotKeyData,
  }) {
    return HotKeyPageState(
      friendData: friendData ?? this.friendData,
      hotKeyData: hotKeyData ?? this.hotKeyData,
    );
  }
}

class HotKeyNotifier extends AsyncNotifier<HotKeyPageState> {
  @override
  Future<HotKeyPageState> build() async {
    return _loadData();
  }

  Future<HotKeyPageState> refresh() async {
    final next = await _loadData(previous: state.asData?.value);
    state = AsyncData(next);
    return next;
  }

  Future<HotKeyPageState> _loadData({HotKeyPageState? previous}) async {
    final current = previous ?? const HotKeyPageState();
    var friendData = current.friendData;
    var hotKeyData = current.hotKeyData;

    try {
      final friendRes = await Request.get<List<FriendModelEntity>>('/friend/json');
      friendData = friendRes.data ?? friendData;
    } catch (_) {}

    try {
      final hotKeyRes = await Request.get<List<HotKeyModelEntity>>('/hotkey/json');
      hotKeyData = hotKeyRes.data ?? hotKeyData;
    } catch (_) {}

    return current.copyWith(friendData: friendData, hotKeyData: hotKeyData);
  }
}
