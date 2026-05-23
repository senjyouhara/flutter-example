# Research: riverpod coexistence

- **Query**: Riverpod coexistence best practices for a Flutter app that already uses provider/ChangeNotifier globally; Home-only refactor scope
- **Scope**: mixed
- **Date**: 2026-05-23

## Findings

### Files Found

| File Path | Description |
|---|---|
| `lib/app.dart` | Root `MultiProvider` injects global `ChangeNotifierProvider<LoginViewModel>` at `app.dart:47-50`. |
| `lib/pages/home/home_page.dart` | Home owns its own `HomeViewModel` via local `ChangeNotifierProvider` at `home_page.dart:82-85`; favorite action reads global login state at `home_page.dart:113`. |
| `lib/pages/home/home_vm.dart` | Home feature state is already feature-local (`bannerData`, `listData`, paging, collect actions). |
| `lib/pages/login/login_vm.dart` | Login/session state is app-wide mutable `ChangeNotifier` with `userInfo`, `login`, `logout`, `getInfo`. |
| `pubspec.yaml` | `flutter_hooks`, `riverpod`, and `provider` are all installed at `pubspec.yaml:34-41`; no Riverpod usage exists in `lib/**`. |

### Code Patterns

- App-wide session state is currently rooted in Provider, not Home: `ChangeNotifierProvider<LoginViewModel>(create: (context) => vm)` in `lib/app.dart:49`.
- Home is already a natural migration boundary because its main state is local to the page: `HomeViewModel vm = new HomeViewModel();` and local provider wiring in `lib/pages/home/home_page.dart:29,82-85`.
- Home only has one direct dependency on global login state in the provided excerpt: `if(context.read<LoginViewModel>().userInfo == null)` at `lib/pages/home/home_page.dart:113`.
- Session persistence/identity is centralized in `LoginViewModel` (`userInfo`, `SpUtil`, `login/logout/getInfo`) at `lib/pages/login/login_vm.dart:7-35`, so moving Home alone does not require moving auth storage first.

### External References

- [Riverpod Motivation](https://riverpod.dev/docs/from_provider/motivation) — Riverpod explicitly says temporary use of Provider and Riverpod together is supported, and migration can be incremental.
- [From ChangeNotifier](https://riverpod.dev/docs/migration/from_change_notifier) — Riverpod documents `ChangeNotifierProvider` in Riverpod as a transition tool for smooth migration from `package:provider`.
- [Provider vs Riverpod](https://riverpod.dev/docs/from_provider/provider_vs_riverpod) — Riverpod requires `ProviderScope` and reads through `WidgetRef`, but this does not require removing existing Provider widgets immediately.
- [Consumers](https://riverpod.dev/docs/concepts2/consumers) — a single page can switch to `ConsumerWidget`/`ConsumerStatefulWidget` while the rest of the app stays on normal Flutter/provider widgets.
- [Riverpod ChangeNotifierProvider](https://docs-v2.riverpod.dev/docs/providers/change_notifier_provider) — Riverpod discourages long-term `ChangeNotifierProvider`, but keeps it mainly for transition from provider.

### Direct Answers

1. **Migrate one feature/page first?** Yes. This is reasonable and aligned with Riverpod’s official migration story, especially because Home already owns feature-local state separate from global auth.
2. **Can Riverpod coexist with provider temporarily?** Yes. Safe temporary setup is: keep existing root `provider` tree for `LoginViewModel`, add a root `ProviderScope` for Riverpod, and migrate only Home’s local state consumption/creation to Riverpod widgets/providers.
3. **How should Home read login state during the transition?** Safest short-term choice is to keep login/session reads on existing Provider for now, because auth is app-level, already shared across unrelated screens, and Home currently only performs a simple guard read. Bridge only if Home must react to auth changes through Riverpod APIs; otherwise defer auth migration.
4. **Safest minimal migration boundary?** Convert only Home feature-local state (`HomePage` + `HomeViewModel` responsibilities such as banner/list/paging/collect actions) to Riverpod, while leaving `LoginViewModel` global provider ownership unchanged until a separate auth-wide migration.

### Related Specs

- `.trellis/spec/frontend/state-management.md` — current repo rule says app-level shared state uses root Provider (`LoginViewModel`), while page-level domain state stays feature-local.
- `.trellis/spec/frontend/hook-guidelines.md` — current spec warns against isolated hook adoption without a deliberate feature-boundary migration plan.

## Caveats / Not Found

- Current repo specs still describe Provider as the active project convention, so a Home-only Riverpod change is a deliberate exception rather than an already-established house style.
- No existing Riverpod code was found in `lib/**`, so any coexistence setup will be the first Riverpod integration in this codebase.
