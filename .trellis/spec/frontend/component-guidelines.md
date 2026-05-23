# Component Guidelines

> How widgets are built and composed in this Flutter project.

---

## Overview

The codebase uses plain Flutter widgets first, with `HookConsumerWidget` as the default page shape for migrated feature screens that own controllers or lifecycle-driven UI state. Shared UI is extracted into `lib/components/`, while feature pages stay under `lib/pages/<feature>/`. Widgets should be composed around constructor input, callbacks, and provider state, not around hidden global behavior.

---

## Component Structure

### Feature pages

Migrated feature pages are usually `HookConsumerWidget` screens that:

- own page-local controllers and helper objects with hooks
- trigger first-frame loading with `useEffect` plus `addPostFrameCallback` when UI context is required
- compose shared widgets and feature widgets
- read Riverpod providers and call notifier methods for domain mutations

Lighter screens that do not need hook-owned state may stay `ConsumerWidget` or plain widgets.

Example references:

- `lib/pages/home/home_page.dart`
- `lib/pages/login/login_page.dart`
- `lib/pages/search/search_page.dart`
- `lib/pages/tabbar_page.dart`

### Shared widgets

Shared widgets should stay focused on rendering and interaction.

Examples:

- `NavigationBarWidget` renders a reusable bottom navigation shell
- `Loading` exposes a shared loading overlay API
- `PostItemWidget` renders article-style content for multiple flows

Shared widgets may accept callbacks, but should not embed feature-only request code.

---

## Constructor and Field Conventions

- Use constructor parameters to pass data in.
- Prefer `final` widget fields when the value does not change after construction.
- Use named optional arguments for optional behavior.
- Use callback arguments for parent-owned actions.

Example patterns already present in the repo:

- `NavigationBarWidget({required this.pages, this.onTabChanged})`
- `LabelIcons({String? label, Widget? icon, Widget? page})`

When a helper data carrier such as `LabelIcons` is only used by one shared component, keep it next to that component.

---

## Composition Rules

1. Pages assemble the screen.
2. Shared widgets render reusable fragments.
3. Parent widgets own navigation decisions.
4. Parent widgets own feature mutations such as collect/uncollect or login success handling.

Example: `HomePage` renders `PostItemWidget` and passes `onFavoriteTap`; the page decides whether login is required and which notifier method to call.

---

## Styling Patterns

- Use `flutter_screenutil` sizing helpers such as `.w`, `.h`, `.sp`, and `.r` for screen-scaled values.
- Use app-level `ThemeData` from `MaterialApp` as the base theme.
- Keep widget-local styling close to the widget when the style is not shared.
- Extract a helper method in the same page when multiple fields share the same decoration pattern.

Example: `LoginPage.textFormCommonInputDecoration()` centralizes repeated input decoration for the page.

---

## Accessibility and Interaction

- Prefer Material widgets (`TextFormField`, `OutlinedButton`, `TextButton`, `BottomNavigationBar`) over gesture-only controls when a semantic control exists.
- Keep tappable areas wrapped in visible UI or explicit gesture handlers.
- When building navigation items, ensure each item has both icon and label.
- Avoid invisible actions without labels unless the platform pattern clearly allows it.

---

## Common Mistakes

### Don’t move feature code into shared widgets too early

If the widget depends on one feature's VM or one page's route arguments, keep it in the feature module.

### Don’t make shared widgets decide app flow

Navigation, auth checks, and persistence writes belong in the page or VM layer.

### Don’t mix multiple scrolling owners accidentally

When embedding `ListView` inside another scrollable widget, match the existing pattern: `shrinkWrap: true` plus `NeverScrollableScrollPhysics()` when the outer container owns scrolling.

---

## Wrong vs Correct

### Wrong

```dart
class FavoriteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await Request.post('/lg/collect/1/json');
      },
      icon: const Icon(Icons.favorite),
    );
  }
}
```

### Correct

```dart
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.onTap});

  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.favorite),
    );
  }
}
```
