# Directory Structure

> How Flutter client code is organized in this project.

---

## Overview

The app is organized by feature first, then by shared infrastructure. New code should fit the existing `pages + components + utils + routes` layout instead of introducing a second structure.

---

## Directory Layout

```text
lib/
├── main.dart
├── app.dart
├── config.dart
├── components/
│   ├── loading.dart
│   ├── post_item.dart
│   ├── navigation_bar/
│   └── wbview/
├── constants/
│   └── sp_constants.dart
├── extensions/
├── generated/
│   └── json/
├── pages/
│   ├── about/
│   ├── home/
│   ├── hot_key/
│   ├── knowledge/
│   ├── login/
│   ├── personal/
│   ├── register/
│   ├── search/
│   ├── webview/
│   └── tabbar_page.dart
├── routes/
│   ├── routes.dart
│   └── route_utils.dart
└── utils/
    ├── permission_util.dart
    ├── sp_util.dart
    └── request/
        ├── base_model_entity.dart
        ├── cookie_interceptor.dart
        ├── request.dart
        ├── request_interceptor.dart
        └── resp_interceptor.dart
```

---

## Module Organization

### Feature modules

Each feature lives under `lib/pages/<feature>/` and usually contains:

- `*_page.dart` — widget tree and screen-level UI
- `*_vm.dart` — Riverpod provider / notifier boundary for that feature, or another feature-local state/action entry point when no long-lived state is needed
- `*_model_entity.dart` — API model types used by the feature
- extra detail pages or helper widgets when the feature needs them

Examples:

- `lib/pages/login/login_page.dart`
- `lib/pages/login/login_vm.dart`
- `lib/pages/login/login_model_entity.dart`
- `lib/pages/knowledge/detail/knowledge_detail_page.dart`

### Shared UI

Put reusable visual building blocks in `lib/components/`.

Examples:

- `lib/components/loading.dart`
- `lib/components/navigation_bar/navigation_bar_widget.dart`
- `lib/components/post_item.dart`

If a widget only makes sense inside one feature, keep it inside that feature instead of moving it into `components/` too early.

### Shared infrastructure

- `lib/routes/` owns route names, route registration, and navigation helpers.
- `lib/utils/request/` owns all HTTP access, interceptors, and response parsing.
- `lib/utils/sp_util.dart` owns `shared_preferences` access.
- `lib/constants/sp_constants.dart` owns persistence keys.
- `lib/generated/json/` is generated code and is not hand-edited.

---

## Naming Conventions

- Screen widgets: `*_page.dart`
- View models: `*_vm.dart`
- API entities: `*_model_entity.dart`
- Shared widgets: noun-based names such as `loading.dart`, `post_item.dart`
- Route registry: `routes.dart`
- Imperative helper wrappers: `*_util.dart`

Keep the feature folder name aligned with the route or domain name where possible.

---

## Placement Rules

### Put code in `pages/<feature>/` when

- it belongs to one screen or one domain flow
- it depends on one feature's model or provider/notifier boundary
- it is unlikely to be reused outside that feature

### Put code in `components/` when

- it is visual UI reused by multiple pages
- it does not own feature-specific request logic
- it can receive everything it needs through constructor arguments and callbacks

### Put code in `utils/` only when

- it is cross-feature infrastructure
- it has no screen-specific rendering concern
- it wraps a package or platform concern used by multiple features

---

## Wrong vs Correct

### Wrong

- putting a feature-only widget under `components/` just because it is large
- putting HTTP calls directly inside a page widget
- creating a second app structure such as `lib/src/feature/...` next to the current one

### Correct

- keep request logic in `lib/utils/request/`
- keep screen orchestration in `*_page.dart`
- keep feature state mutations in `*_vm.dart`
- keep generated serializers under `lib/generated/json/`
