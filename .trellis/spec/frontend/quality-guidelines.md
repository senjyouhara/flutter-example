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

## Scenario: Git hook and commit quality enforcement

### 1. Scope / Trigger
- Trigger: adding or changing local git hooks, commit message policy, or CI quality gates for this Flutter repo.
- Trigger: any change that affects how `flutter analyze`, commit message validation, or test execution is enforced before sharing code.

### 2. Signatures
- `lefthook.yml`
- `pre-commit` -> `dart format {staged_files}`
- `commit-msg` -> `dart run tool/validate_commit_messages.dart --message-file "{1}"`
- `pre-push` -> `flutter analyze`
- CI PR range -> `dart run tool/validate_commit_messages.dart --from <base-sha> --to <head-sha>`
- CI push fallback -> `dart run tool/validate_commit_messages.dart --from <base-sha> --to <head-sha>` or `--last`
- Commit examples -> `tool/commit_message_examples.txt`

### 3. Contracts
- Commit headers must follow Conventional Commits: `<type>(optional-scope): short imperative summary` or `<type>(optional-scope)!: short imperative summary`.
- Allowed commit types are `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, and `test`.
- Optional scopes must stay lowercase and machine-parseable so the same validator can run locally and in CI.
- `commit-msg` and CI must call the same Dart validator entrypoint; do not maintain a second regex in workflow YAML.
- `pre-commit` stays fast and only formats staged `.dart` files.
- `pre-push` runs `flutter analyze`; it does not become a second full CI pipeline.
- When the repo has no `test/` or `integration_test/` directory, CI may skip `flutter test` with an explicit message rather than inventing placeholder tests.
- `tool/commit_message_examples.txt` is the in-repo reference for accepted commit message shapes; it is guidance, not a required git template.

### 4. Validation & Error Matrix
- Invalid Conventional Commit header -> fail `commit-msg` and fail CI commit-range validation.
- Empty commit header -> fail validation.
- `Merge ` / `fixup! ` / `squash! ` / `Revert "` headers -> ignore in validator rather than blocking Git's generated messages.
- New branch first push with all-zero `before` SHA -> compute a base commit and validate the full branch range, not just the last commit.
- Missing `test/` and `integration_test/` directories -> skip `flutter test` in CI with an explicit log line.
- Staged non-Dart files only -> `pre-commit` should not try to format unrelated files.

### 5. Good / Base / Bad Cases
- Good: `feat(ci): add lefthook commit checks`
- Good: `refactor(routes)!: rename article route arguments`
- Base: `chore: update hook command names`
- Bad: `update`
- Bad: `fix bug`
- Bad: `WIP`

### 6. Tests Required
- Smoke-test the validator with one valid message file and one invalid message file.
- Verify `dart format --output=none --set-exit-if-changed tool/validate_commit_messages.dart` stays clean.
- Run `dart analyze tool/validate_commit_messages.dart`.
- Run `flutter analyze` and record clearly if failures come from pre-existing repo-wide issues outside the hook task.
- Verify `pre-commit` only reformats staged `.dart` files and re-stages fixes.
- Verify CI logic covers both PR commit ranges and first-push/default-push paths.

### 7. Wrong vs Correct
#### Wrong

```yaml
commit-msg:
  commands:
    conventional-commits:
      run: dart run tool/validate_commit_messages.dart --message-file "{1}"

# workflow also keeps a second hard-coded regex or only checks the last commit
```

#### Correct

```yaml
commit-msg:
  commands:
    conventional-commits:
      run: dart run tool/validate_commit_messages.dart --message-file "{1}"
```

```bash
dart run tool/validate_commit_messages.dart --from <base-sha> --to <head-sha>
```

## Code Review Checklist

- Is the code placed in the correct feature/shared folder?
- Does networking go through `Request`?
- Does persistence go through `SpUtil` + `SpConstants`?
- Is navigation using the shared route table and helpers?
- Are models typed instead of parsed as raw maps?
- Does the notifier publish a new state snapshot after mutation?
- Does the change avoid introducing a competing architecture for just one screen?
- If hook or CI config changed, do local `commit-msg` and CI reuse the same validator entrypoint?
- If hook or CI config changed, does `pre-commit` stay fast and scoped to staged-file formatting?
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
