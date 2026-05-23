# Quality Guidelines

> Code quality and consistency rules for the Flutter client.

---

## Overview

Quality in this project means staying consistent with the existing Flutter architecture:

- route table driven navigation
- request wrapper driven networking
- Riverpod-driven state
- typed entities and generated JSON conversion
- shared wrappers for persistence and loading feedback

A small, consistent implementation is preferred over introducing a newer framework abstraction for one feature.

---

## Forbidden Patterns

### Don’t bypass the shared request layer

Do not instantiate `Dio` inside pages or feature VMs. Use `Request.get/post/put/delete/download` so interceptors, cookies, error handling, and envelope parsing stay consistent.

### Don’t bypass shared persistence wrappers

Do not spread raw `SharedPreferences` access through feature code. Use `SpUtil` and key names from `SpConstants`.

### Don’t mix navigation systems

The project currently routes through `Routes.generateRoutes`, `RoutesPath`, and `RouteUtils`. Do not introduce one-off `go_router` or unrelated navigation stacks inside a feature.

### Don’t hand-edit generated JSON files

Anything in `lib/generated/json/` must be regenerated, not manually patched.

### Don’t introduce a second state-management architecture casually

Avoid mixing Riverpod, hooks, and singleton-managed state inside the same active code path.

---

## Required Patterns

### Use the shared app bootstrap

Initialization that must happen before app startup belongs in `main.dart` before `runApp()`, such as `SpUtil.getInstance()` and platform/webview setup.

### Keep route registration centralized

New named routes must be added in `lib/routes/routes.dart` and routed through `RoutesPath` / `Routes.generateRoutes`.

### Keep feature mutations in VMs

Requests, list updates, and domain mutations should live in `*_vm.dart`; widgets orchestrate user interaction and rendering.

### Use shared feedback helpers

Use `Loading` and `showToast` patterns already established by the app rather than inventing parallel loading UX per page.

### Use responsive size helpers consistently

When the page already uses `ScreenUtil`, keep sizing in `.w`, `.h`, `.sp`, and `.r` rather than mixing raw pixel literals randomly.

---

## Testing Requirements

This repo is UI-heavy, so code changes require both automated and manual checks when relevant.

### Minimum checks for logic changes

- run `flutter analyze`
- run targeted `flutter test` when tests exist or when adding logic-heavy code

### Manual verification required for UI flow changes

Verify the real screen flow when touching:

- login / logout
- tab navigation
- pull-to-refresh / load more
- webview launch or route argument handling
- persistence-backed user state

### Assertion points

- provider/notifier state changes after successful async action
- route arguments reach the target page
- loading overlay is dismissed on success and failure paths
- persisted user state is written or cleared through `SpUtil`

---

## Code Review Checklist

- Is the code placed in the correct feature/shared folder?
- Does networking go through `Request`?
- Does persistence go through `SpUtil` + `SpConstants`?
- Is navigation using the shared route table and helpers?
- Are models typed instead of parsed as raw maps?
- Does the notifier publish a new state snapshot after mutation?
- Does the change avoid introducing a competing architecture for just one screen?
- If UI changed, was the actual screen flow verified?

---

## Wrong vs Correct

### Wrong

```dart
final dio = Dio();
final response = await dio.get('https://www.wanandroid.com/banner/json');
```

### Correct

```dart
final response = await Request.get<List<HomeModelEntity>>('/banner/json');
```
