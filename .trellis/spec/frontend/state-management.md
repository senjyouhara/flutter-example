# State Management

> How state is owned, exposed, and persisted in this project.

---

## Overview

The app uses Riverpod for shared app state and feature-scoped async page state. State is still split by scope instead of by framework abstraction novelty.

Current state layers are:

- app-level shared state: root Riverpod provider under `ProviderScope`
- page-level domain state: feature-scoped `NotifierProvider`, `AsyncNotifierProvider`, or `Provider` action boundary as appropriate
- page-local ephemeral state: widget fields / controllers / helper objects
- persisted session state: `SpUtil` + `SpConstants`

---

## State Categories

### 1. App-level shared state

Use a root Riverpod provider when the state must be visible across unrelated screens.

Current example:

- `authProvider` in `lib/pages/login/login_vm.dart` owns login/session state
- screens such as `HomePage` and `PersonalPage` read `authProvider` to check whether the user is logged in

### 2. Page-level domain state

Use a feature-local Riverpod provider for screen-owned domain state.

Current examples:

- `homeProvider` owns banner, list, pagination, and favorite state for `HomePage`
- `knowledgeProvider`, `knowledgeDetailProvider`, `searchProvider`, and `favoriteProvider` own their respective list flows
- `registerActionProvider` exposes the register submit action without pushing form controllers into shared state

### 3. Page-local ephemeral state

Keep purely local UI concerns in the widget layer:

- current tab index
- current page number for list loading when it is only a widget concern
- form key and text controllers
- temporary validation strings or focus behavior
- `RefreshController` and focus nodes

Examples:

- `refreshController` owned by hooks in `HomePage`, `KnowledgePage`, and `FavoritePage`
- form keys and text controllers owned by hooks in `LoginPage` and `RegisterPage`
- selected tab index inside `NavigationBarWidget`

### 4. Persisted state

Persist only the values that must survive app restart.

Current examples:

- `SpConstants.userInfo`
- `SpConstants.cookies`

All persistence should go through `SpUtil`, not direct `SharedPreferences` calls spread through features.

---

## When to Use Global State

Promote state to app-level only when all of these are true:

1. multiple unrelated pages need to read it
2. the state must survive route changes cleanly
3. keeping separate copies would create inconsistency

Use app-level Riverpod providers for:

- login/session identity
- future app-wide settings
- future global capability state such as theme or locale

Do not promote a feature list, page filter, or one screen's loading flag to global state.

---

## Notifier Rules

- Providers and notifiers own async domain actions and observable feature data.
- Widgets call notifier methods and render provider state.
- After mutating observable state, assign a new Riverpod state snapshot.
- Notifiers should not own `BuildContext`, route decisions, or widget controllers.

Examples already present:

- `AuthNotifier.login()` performs the request, persists user info, and updates auth state
- `HomeNotifier.refresh()` and `HomeNotifier.loadNextPage()` fetch data and publish a new `HomePageState`

---

## Server State

The app does not use a dedicated server-state cache library. Remote data is requested through `Request` and stored in Riverpod state owned by the feature boundary.

Patterns to follow:

- request in the notifier/action boundary
- assign typed result to immutable state
- replace provider state after mutation
- keep pagination and refresh orchestration in the owning feature boundary

Do not split one feature across two runtime state models casually.

---

## Common Mistakes

### Don’t store widget controllers in notifiers

`TextEditingController`, `FormState`, `RefreshController`, and focus nodes belong to the widget layer.

### Don’t use shared providers for one-off local state

A local tab index or form input helper should stay inside the page, not in app-level shared state.

### Don’t bypass `SpUtil` for persistence

If one feature writes keys directly and another uses `SpUtil`, persistence behavior becomes inconsistent.

### Don’t blur ownership between hooks and Riverpod

Use hooks for widget-local lifecycle objects and temporary UI values, and use Riverpod for observable domain state and async mutations. Do not move the same concern back and forth between the two layers inside one feature.

---

## Wrong vs Correct

### Wrong

```dart
class SearchNotifier extends AsyncNotifier<SearchPageState> {
  final controller = TextEditingController();
  int currentTab = 0;
}
```

### Correct

```dart
class SearchNotifier extends AsyncNotifier<SearchPageState> {
  Future<void> search(String keyword) async {
    final result = await Request.post<SearchModelEntity>(
      '/article/query/0/json',
      queryParameters: {'k': keyword},
    );
    state = AsyncData(
      SearchPageState(searchList: result.data?.datas ?? const []),
    );
  }
}
```
