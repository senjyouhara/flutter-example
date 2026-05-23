# Research: riverpod-home-patterns

- **Query**: Best practices for migrating Flutter Home screen from StatefulWidget + ChangeNotifierProvider to flutter_hooks + riverpod, covering architecture, page-layer hook usage, and clean loading/error/refresh/pagination state.
- **Scope**: mixed
- **Date**: 2026-05-23

## Findings

### Files Found

| File Path | Description |
|---|---|
| `lib/pages/home/home_page.dart` | Current page owns startup, refresh, load-more, and favorite tap orchestration. |
| `lib/pages/home/home_vm.dart` | Current VM owns banner/list fetch and collect/uncollect requests. |
| `lib/pages/home/home_list_model_entity.dart` | List item model includes `collect`, `id`, `title`, `link`. |
| `.trellis/spec/frontend/state-management.md` | Current repo spec is Provider + ChangeNotifier based. |
| `.trellis/spec/frontend/hook-guidelines.md` | Current repo spec says hooks are not the active convention yet. |
| `.trellis/spec/frontend/quality-guidelines.md` | Current repo spec requires requests in VMs and shared wrappers. |
| `pubspec.yaml` | `flutter_hooks` and `riverpod` exist, but `hooks_riverpod` is not declared. |

### Code Patterns

- Current page state is split between widget-local fields and VM fields:
  - `HomePage` owns `RefreshController _refreshController` and `int _page` (`lib/pages/home/home_page.dart:30-32`).
  - `HomeViewModel` owns `bannerData`, `listData`, `pageTotal`, `isPageEnd`, `topListData` (`lib/pages/home/home_vm.dart:10-14`).
- Startup currently runs after first frame and performs two separate requests:
  - `await vm.getBanner();` and `await vm.getListData(_page);` (`lib/pages/home/home_page.dart:41-55`).
- Refresh resets page to 1 and refetches banner + list (`lib/pages/home/home_page.dart:58-65`).
- Load-more increments `_page` and appends data through `vm.getListData(_page)` (`lib/pages/home/home_page.dart:67-77`, `lib/pages/home/home_vm.dart:28-39`).
- Favorite toggle is optimistic in UI timing but mutation is page-owned today:
  - collect/uncollect request is awaited, then `item.collect` is flipped, then `vm.updateListData(item, index)` notifies listeners (`lib/pages/home/home_page.dart:111-126`, `lib/pages/home/home_vm.dart:16-19,48-61`).
- Item model already exposes the fields needed for optimistic updates: `bool? collect`, `int? id`, `String? title`, `String? link` (`lib/pages/home/home_list_model_entity.dart:37,44,60,46`).

### External References

- [Riverpod: About hooks](https://riverpod.dev/docs/concepts/about_hooks) — hooks are independent from Riverpod; use `HookConsumerWidget` only when one widget needs both hooks and provider reads.
- [Riverpod: Implementing pull-to-refresh](https://riverpod.dev/docs/how_to/pull_to_refresh) — recommended refresh flow is `onRefresh: () => ref.refresh(provider.future)`; `AsyncValue` keeps prior data visible during refresh.
- [Riverpod: From StateNotifier](https://riverpod.dev/docs/migration/from_state_notifier) — newer Riverpod guidance prefers `Notifier`/`AsyncNotifier` over `StateNotifier`; initialization belongs in `build`, and public methods handle side effects.
- [Riverpod AsyncNotifier API](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncNotifier-class.html) — `AsyncNotifier` is intended for async initialization plus public mutation methods; `update` helps mutate from previous async state.
- [Riverpod AsyncNotifierProvider API](https://pub.dev/documentation/hooks_riverpod/latest/hooks_riverpod/AsyncNotifierProvider-class.html) — class-based async provider for state with side effects.
- [Riverpod AsyncValue API](https://pub.dev/documentation/hooks_riverpod/latest/hooks_riverpod/AsyncValue-class.html) — clean representation for loading/data/error; useful with pattern matching and `isRefreshing`/previous-data rendering patterns from Riverpod refresh docs.
- [Riverpod Mutations (experimental)](https://riverpod.dev/docs/concepts2/mutations) — optional pattern when UI must react to pending/error/success of a specific mutation such as favorite toggling.

### Actionable best-practice mapping for this screen

1. **Screen architecture**
   - Use one feature provider as the page state source, preferably a class-based `AsyncNotifierProvider` for a `HomeScreenState` value.
   - Put screen bootstrap in `build()` of the notifier: banner fetch + first page fetch.
   - Expose public notifier methods for `refresh()`, `loadNextPage()`, and `toggleFavorite(itemId)`.
   - Keep networking behind repository/service methods that still call the shared `Request` wrapper, matching `.trellis/spec/frontend/quality-guidelines.md:23-26,55-62`.

2. **State shape**
   - Model page data as one immutable state object, e.g. banner list + article list + page index/cursor + `hasMore` + mutation markers.
   - Wrap that object in `AsyncValue<HomeScreenState>` so initial load/error is handled by Riverpod.
   - Keep pagination/refresh substate inside the data object instead of replacing everything with a separate loading enum; common flags are `isLoadingMore`, `isRefreshing`, and `favoritePendingIds`.

3. **Refresh/load-more modeling**
   - Initial load: provider `build()` returns first full snapshot.
   - Pull-to-refresh: call `ref.refresh(homeProvider.future)` or a notifier `refresh()` that replaces the first-page snapshot; Riverpod refresh docs note old data can stay visible while refresh is pending.
   - Load-more: do not convert the whole screen back to full-screen loading; append next page from previous value and guard with `hasMore`/`isLoadingMore`.

4. **Optimistic favorite toggle**
   - Keep the toggle method on the notifier, not the page.
   - Update the target item immediately from previous state, remember pending id, perform request, and revert that item if the request fails.
   - If favorite state needs button-level pending/error UI, Riverpod `Mutation` is relevant but marked experimental; a notifier-owned pending-id set is the more stable documented path.

5. **flutter_hooks at page layer**
   - Use hooks only for widget-local objects/lifecycle glue: `useMemoized`/`useEffect` for a `RefreshController` or scroll controller, `useCallback` for stable closures when helpful.
   - Do not move domain state into hooks when Riverpod provider state already owns it.
   - Prefer `HookConsumerWidget` for the page only if hooks are truly needed there; otherwise `ConsumerWidget` is enough and keeps hook usage minimal.
   - Local ephemeral UI state that never matters outside rendering can stay in hooks; fetched data, paging state, and favorite mutation state should stay in Riverpod.

### Related Specs

- `.trellis/spec/frontend/state-management.md` — current project contract is Provider + ChangeNotifier.
- `.trellis/spec/frontend/hook-guidelines.md` — current project contract says hook-based composition is not yet the active feature convention.
- `.trellis/spec/frontend/quality-guidelines.md` — keep requests in shared `Request` flow and mutations out of widgets.

## Caveats / Not Found

- The repo currently declares `flutter_hooks` and `riverpod` in `pubspec.yaml:34-36`, but no `hooks_riverpod` dependency was found in `pubspec.yaml`.
- Current repo specs explicitly describe Provider/ChangeNotifier as the active convention, so migration work should account for that documented baseline.
- `python3 ./.trellis/scripts/task.py current --source` could not be executed here because the environment denied `python3`; the user-provided task directory was used directly.
