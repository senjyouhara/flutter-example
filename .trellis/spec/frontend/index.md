# Frontend Development Guidelines

> Executable guidance for the Flutter client in this project.

---

## Overview

This frontend is a Flutter application built around:

- `StatefulWidget` / `StatelessWidget`
- `hooks_riverpod` + Riverpod notifiers for shared app and feature state
- `flutter_hooks` for widget-owned controllers in migrated feature boundaries
- Centralized route table in `lib/routes/routes.dart`
- `dio` wrapped by `lib/utils/request/request.dart`
- `shared_preferences` wrapped by `lib/utils/sp_util.dart`
- Screen adaptation through `flutter_screenutil`

Use the surrounding feature's existing widget composition pattern, but keep runtime state wiring on Riverpod.

---

## Guidelines Index

| Guide | Description | Status |
|-------|-------------|--------|
| [Directory Structure](./directory-structure.md) | Real module layout and file placement rules | Ready |
| [Component Guidelines](./component-guidelines.md) | Widget composition, parameters, and UI reuse rules | Ready |
| [Hook Guidelines](./hook-guidelines.md) | How lifecycle logic is handled in this codebase | Ready |
| [State Management](./state-management.md) | Riverpod ownership and widget-local state rules | Ready |
| [Networking & API Contracts](./networking-and-api-contracts.md) | Request wrapper, response envelope, and interceptor behavior | Ready |
| [Quality Guidelines](./quality-guidelines.md) | Required patterns and forbidden shortcuts | Ready |
| [Type Safety](./type-safety.md) | Model placement, generated code, and generic parsing rules | Ready |

---

## Working Rules

1. Prefer the project's current Flutter stack over unused dependencies.
2. Keep feature code inside `lib/pages/<feature>/` unless it is truly shared.
3. Route navigation, request handling, persistence, and model parsing must use the shared project wrappers.
4. Do not document ideal architecture that the repo does not follow today; document and extend the architecture that already exists.

---

**Language**: Documentation is written in English so future sessions and tooling can reuse it consistently.
