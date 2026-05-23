# Refactor Home Page to flutter_hooks and riverpod best practices

## Goal

Refactor `lib/pages/home/home_page.dart` from the current `StatefulWidget + local ChangeNotifierProvider<HomeViewModel>` structure into a `flutter_hooks + riverpod` implementation that follows current Riverpod best practices, while preserving the Home page's existing user-visible behavior and minimizing unnecessary blast radius.

## What I already know

- The current Home page owns startup loading, refresh, load-more, and favorite orchestration in `lib/pages/home/home_page.dart`.
- The current `HomeViewModel` owns banner fetch, list fetch, pagination append, and collect/uncollect requests in `lib/pages/home/home_vm.dart`.
- Global login/session state is still rooted in `provider` via `ChangeNotifierProvider<LoginViewModel>` in `lib/app.dart`.
- The Home page currently reads global login state only as a guard before favorite actions.
- `flutter_hooks` and `riverpod` are already declared in `pubspec.yaml`, but `hooks_riverpod` is not present.
- There is currently no Riverpod usage anywhere under `lib/**`.

## Assumptions (temporary)

- This is a behavior-preserving refactor, not a product change.
- Existing interactions should continue to work: banner, list, pull-to-refresh, load-more, favorite toggle, login guard, and webview navigation.
- Requests should continue to use the shared `Request` wrapper and existing entity models.
- Routes, persistence wrappers, and WanAndroid response handling are out of scope unless migration requires minimal wiring.

## Open Questions

- None. Migration boundary is confirmed.

## Requirements

- Replace Home page widget composition with a hooks-based + Riverpod-based implementation.
- Follow Riverpod's current recommended direction (`Notifier` / `AsyncNotifier` style), not a new `ChangeNotifier` wrapped by Riverpod.
- Keep domain/networking logic out of widget build methods.
- Keep API access on top of the shared `Request` layer.
- Preserve current Home page behaviors: banner, list, pull-to-refresh, load-more, favorite toggle, unauthenticated favorite guard, and webview navigation.
- Limit migration scope to Home feature-local state so unrelated screens do not need to be rewritten.
- Keep global login/session ownership in existing `provider` / `LoginViewModel`; Home may continue reading it only for the favorite guard.

## Acceptance Criteria (evolving)

- [ ] Home screen no longer uses local `ChangeNotifierProvider<HomeViewModel>`.
- [ ] Home screen state is provided by Riverpod and consumed from a Riverpod-aware widget.
- [ ] Widget-local ephemeral objects use hooks only where they add value.
- [ ] Initial load still fetches banner + first page.
- [ ] Pull-to-refresh still reloads banner + first page.
- [ ] Load-more still appends next page and respects end-of-list behavior.
- [ ] Favorite / unfavorite still works and still guards unauthenticated users.
- [ ] Tapping a list item still routes to webview with the correct arguments.

## Definition of Done (team quality bar)

- Relevant lint/type checks pass
- Relevant tests added or updated if practical in this repo
- Manual verification completed for Home screen golden flow
- No unrelated route/request/persistence regressions introduced
- Trellis spec updates added if new project conventions are introduced

## Technical Approach

Initial direction based on repo inspection and research:

- Use a feature-scoped Riverpod provider for Home screen state.
- Prefer a single immutable screen-state model wrapped by `AsyncValue` rather than multiple mutable widget fields.
- Move `refresh()`, `loadNextPage()`, and `toggleFavorite(...)` into the Riverpod notifier layer.
- Use hooks only for widget-local controller/lifecycle glue such as refresh controller management.
- Keep global auth on existing `provider` during this migration; Home keeps the login guard read against `LoginViewModel` rather than introducing an auth bridge.

## Decision (ADR-lite)

**Context**: The repo currently uses `provider + ChangeNotifier`, but the requested task explicitly asks for `flutter_hooks + riverpod` best practices on Home.

**Decision**: Introduce Riverpod first at the Home feature boundary only. Migrate Home's banner/list/paging/favorite feature state to Riverpod, while keeping global login/session ownership and Home's login guard on existing `provider` / `LoginViewModel`.

**Consequences**:
- Pros: keeps migration localized and makes Home follow a more modern state model.
- Trade-off: the repo will temporarily contain both provider and Riverpod.
- Risk: future auth-wide Riverpod migration will still need a separate task, but this avoids expanding the blast radius now.

## Out of Scope (explicit)

- Rewriting all pages from Provider to Riverpod
- Replacing the shared request layer
- Changing route architecture away from `Routes` / `RouteUtils`
- Reworking login flow UX
- Migrating or bridging global auth/session state to Riverpod
- Broad app-wide architecture cleanup unrelated to Home

## Research References

- [`research/riverpod-home-patterns.md`](research/riverpod-home-patterns.md) — recommended screen architecture for async load, refresh, pagination, and optimistic favorite toggling.
- [`research/riverpod-coexistence.md`](research/riverpod-coexistence.md) — safe migration boundary and coexistence strategy with existing `provider` auth state.

## Technical Notes

- Key implementation targets:
  - `lib/pages/home/home_page.dart`
  - `lib/pages/home/home_vm.dart`
  - `lib/app.dart`
  - `pubspec.yaml`
- Current project specs still document Provider as the active convention:
  - `.trellis/spec/frontend/state-management.md`
  - `.trellis/spec/frontend/hook-guidelines.md`
  - `.trellis/spec/frontend/quality-guidelines.md`
- If this migration lands, a follow-up spec update will likely be needed to document the new Riverpod exception or convention.
