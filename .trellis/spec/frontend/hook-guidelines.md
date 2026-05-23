# Hook Guidelines

> How lifecycle-driven logic is handled in this project.

---

## Overview

This project uses hook-based composition plus Riverpod as the preferred pattern for migrated feature screens. Flutter lifecycle methods still exist in untouched legacy areas, but new migration work should align with the hooks-based page shape already used by `home`, `login`, `register`, `search`, `knowledge`, `favorite`, and related screens.

This document defines how hooks are used without moving domain state out of Riverpod notifier boundaries.

---

## Current Pattern

Use hook-based composition for feature pages that own widget lifecycle or controllers:

- `HookConsumerWidget` for pages that need both hooks and provider access
- `useMemoized(...)` for widget-owned helper objects such as `RefreshController`
- `useTextEditingController()` and `useFocusNode()` for form and focus ownership
- `useState(...)` for page-local ephemeral values such as current input text or route-derived title text
- `useEffect(...)` plus `WidgetsBinding.instance.addPostFrameCallback(...)` when startup work needs UI context after first frame
- Riverpod notifier methods for async domain work

Examples:

- `HomePage` owns `RefreshController` with `useMemoized` and observes `homeProvider` through `HookConsumerWidget`
- `SearchPage` owns `FocusNode`, `TextEditingController`, and first-frame route bootstrap with hooks
- `LoginPage.onSubmit()` validates the form, shows loading, calls the auth notifier, then routes

---

## Data Fetching

### Page startup

For screen startup requests:

1. trigger from `useEffect(...)` on migrated screens, or `initState()` on untouched legacy screens
2. if overlay/UI context behavior is involved, defer with `addPostFrameCallback`
3. call notifier/action methods rather than writing raw request code in the widget

### User actions

For submit, refresh, collect, or pagination flows:

- keep the click/gesture handler in the page
- call typed VM or notifier methods for request work
- update UI through provider notifications, Riverpod state replacement, or local state as appropriate

---

## Naming Conventions

Use `useXxx` only for actual hook APIs that manage widget-owned state or lifecycle in a migrated feature boundary.

Prefer these names instead:

- `init()` for startup orchestration in legacy pages
- `onSubmit()` / `onRegister()` for UI intent handlers
- `_onRefresh()` / `_onLoading()` for pull-to-refresh style handlers in legacy pages
- `getXxx()` / `updateXxx()` / `logout()` in VMs or notifier methods for domain operations

---

## Migration Rule

Do not introduce `flutter_hooks` as a one-off style experiment inside a feature that otherwise still follows a different ownership model.

If hook-based composition is adopted, migrate the full page boundary deliberately: widget-owned controllers stay in hooks, async/domain state stays in Riverpod notifiers or action providers, and navigation/loading orchestration remains in the page. `home`, `login`, `register`, `search`, `knowledge`, and `favorite` are the reference examples.

---

## Common Mistakes

### Don’t mix two composition models in one feature

Avoid a partial migration where one page uses lifecycle methods and a child subtree uses hooks for the same flow.

### Don’t hide request flow in helper abstractions

If a helper starts owning loading, request, routing, and persistence together, it becomes harder to reason about than the current page + VM split.

### Don’t create fake hooks for non-shared logic

If the logic is page-local, keep it as a private method or a lightweight helper class in the page file.
