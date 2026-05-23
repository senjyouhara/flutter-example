# Migrate remaining pages from provider to riverpod

## Goal

Migrate the remaining provider-based pages and global login state in this Flutter app to Riverpod, so the project can remove `provider` and `ChangeNotifierProvider` from runtime state wiring while preserving current product behavior as the primary constraint and only allowing small opportunistic cleanup where it directly supports the migration.

## What I already know

- `lib/app.dart` still injects `LoginViewModel` through `MultiProvider`, even though `ProviderScope` has already been added around the app.
- `lib/pages/login/login_page.dart` still writes through `context.read<LoginViewModel>()`, so full provider removal requires migrating global auth, not just feature-local page state.
- The remaining provider-bound pages are `register`, `hot_key`, `knowledge`, `knowledge/detail`, `search`, `personal`, and `personal/favorite`.
- `personal` and `favorite` are the main consumers of global login state besides `home`, so auth migration affects multiple unrelated screens.
- `home` has already been migrated to `HookConsumerWidget + AsyncNotifierProvider`, but it still reads login state from `LoginViewModel` as a favorite-action guard.
- `update_dialog.dart` only has a stale `provider` import and no active provider usage.
- Several legacy VMs are thin wrappers around request results, which makes them good candidates for feature-local `AsyncNotifier` migration without preserving `ChangeNotifier` structure.
- The `favorite` feature still uses a typo-shaped file name `fvavorite_vm.dart`; this can be cleaned up during the migration because naming cleanup is explicitly allowed.

## Assumptions (temporary)

- This is a migration and consistency task, not a redesign of navigation, API contracts, or persistence strategy.
- Existing request flow must continue using the shared `Request` wrapper and current entity models.
- Existing persistence for login/session must continue using `SpUtil` and `SpConstants`.
- Route structure stays on `Routes` / `RouteUtils`.

## Open Questions

- None. Scope and migration boundary are confirmed.

## Requirements

- Remove remaining runtime reliance on `provider` / `ChangeNotifierProvider` from the app.
- Migrate `LoginViewModel` and global login/session ownership to Riverpod in this same task.
- Allow app-root cleanup so `ProviderScope` becomes the primary root state container and `MultiProvider` can be removed when no longer needed.
- Preserve current page behavior as the default, while allowing small opportunistic interaction cleanup only when it directly supports the migration and does not alter the main flow.
- Migrate remaining feature-local state by feature boundary rather than introducing half-provider / half-riverpod flows inside the same feature.
- Allow cleanup of provider-shaped naming and file structure where it is directly touched by the migration.
- Keep networking, routing, and persistence on current shared wrappers.

## Acceptance Criteria

- [ ] `lib/app.dart` no longer uses `MultiProvider` / `ChangeNotifierProvider` for login state.
- [ ] Login/session state is exposed through Riverpod and all current readers are updated to consume it.
- [ ] `login_page.dart` no longer uses `context.read<LoginViewModel>()`.
- [ ] `register`, `hot_key`, `knowledge`, `knowledge/detail`, `search`, `personal`, and `favorite` no longer import `provider` for state management.
- [ ] `home_page.dart` no longer reads login state through provider.
- [ ] `update_dialog.dart` no longer carries dead provider imports.
- [ ] Existing flows still work: login, logout, register, search, hot key jump, knowledge menu/detail browsing, favorite list refresh/load/remove, personal page login gate, and Home favorite guard.
- [ ] Any touched provider-centric naming that becomes misleading after migration is cleaned up in the same diff.

## Definition of Done

- Relevant analysis/lint/test commands pass, or any unavailable checks are explicitly called out.
- Manual verification is completed for the main user flows impacted by auth and page-state migration.
- No unrelated route, request, or persistence behavior changes are introduced.
- Trellis specs are updated if this task changes the documented project-wide state-management convention.

## Technical Approach

Use Riverpod at two levels:

1. **Global auth layer**
   - Replace `LoginViewModel` ownership with a Riverpod auth provider.
   - Move initial persisted session bootstrap, login, and logout into the Riverpod auth notifier.
   - Update all auth readers (`login`, `personal`, `favorite`, `home`) to consume the Riverpod auth state.

2. **Feature-local page migration**
   - Convert thin request VMs to feature-local `AsyncNotifier` state boundaries.
   - Keep widget-local controllers and focus/refresh objects in the widget layer, using hooks where the feature is already benefiting from them.
   - Prefer immutable page state objects for paged/list flows.

Recommended implementation order:

1. Auth root migration (`app.dart`, auth provider, `login_page`, auth readers)
2. Thin form-only page cleanup (`register`)
3. Non-auth content features (`hot_key`, `knowledge`, `knowledge/detail`, `search`)
4. Auth-coupled personal features (`personal`, `favorite`)
5. Final cleanup (`home` auth read migration, dead provider imports, naming cleanup such as `fvavorite_vm.dart`)

## Decision (ADR-lite)

**Context**: The repo already contains one migrated Riverpod feature (`home`), but provider still owns app-wide login state and several feature pages. The user explicitly chose one-shot full coverage instead of a phased multi-task migration.

**Decision**: Perform one full migration task that includes both global auth and the remaining feature-local pages, and allow root-container cleanup plus direct naming cleanup where the old provider-centric structure would otherwise remain misleading.

**Consequences**:
- Pros: the app can actually remove provider instead of stopping at partial coexistence.
- Pros: final structure becomes more internally consistent than a feature-by-feature stopgap.
- Trade-off: blast radius is much larger than the Home-only migration and requires broader manual verification.
- Risk: auth migration touches multiple screens, so verification must cover cross-feature login-dependent behavior.

## Out of Scope

- Replacing the shared request wrapper
- Rewriting route architecture
- Redesigning page UX beyond minor migration-adjacent cleanup
- Introducing a third state-management style
- Broad unrelated refactors outside the touched provider migration surface

## Technical Notes

- Verified provider entry points:
  - `lib/app.dart`
  - `lib/pages/login/login_page.dart`
  - `lib/pages/register/register_page.dart`
  - `lib/pages/hot_key/hot_key_page.dart`
  - `lib/pages/knowledge/knowledge_page.dart`
  - `lib/pages/knowledge/detail/knowledge_detail_page.dart`
  - `lib/pages/search/search_page.dart`
  - `lib/pages/personal/person_page.dart`
  - `lib/pages/personal/favorite/favorite_page.dart`
  - `lib/pages/home/home_page.dart`
  - `lib/pages/personal/update_dialog.dart`
- Relevant specs:
  - `.trellis/spec/frontend/state-management.md`
  - `.trellis/spec/frontend/hook-guidelines.md`
  - `.trellis/spec/frontend/networking-and-api-contracts.md`
  - `.trellis/spec/frontend/quality-guidelines.md`
  - `.trellis/spec/frontend/component-guidelines.md`
  - `.trellis/spec/frontend/directory-structure.md`
