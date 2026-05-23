# Research: pre-commit-conventions

- **Query**: Research Flutter/Dart repository conventions for pre-commit checks when adopting lefthook. Focus on what teams typically run locally in pre-commit vs pre-push vs CI, especially for format/analyze/test in Flutter apps.
- **Scope**: mixed
- **Date**: 2026-05-23

## Findings

### Files Found

| File Path | Description |
|---|---|
| `.trellis/tasks/05-23-add-lefthook-and-commit-message-enforcement/task.json` | Active task metadata for this research topic. |
| `.trellis/spec/frontend/quality-guidelines.md:69-77` | Existing project guidance already requires `flutter analyze` and targeted `flutter test` for logic changes. |
| `analysis_options.yaml:1-5` | Root analyzer configuration includes `flutter_lints` and `riverpod_lint`, which means analyzer-based checks are already part of the repo’s quality surface. |

### Code Patterns

- No existing Lefthook configuration was found under the repository root (`**/lefthook*.{yml,yaml,json}` returned no matches).
- Existing project spec says:
  - `.trellis/spec/frontend/quality-guidelines.md:75` — `- run \`flutter analyze\``
  - `.trellis/spec/frontend/quality-guidelines.md:76` — `- run targeted \`flutter test\` when tests exist or when adding logic-heavy code`
- Root analyzer setup is minimal and repo-wide:
  - `analysis_options.yaml:1` — `include: package:flutter_lints/flutter.yaml`
  - `analysis_options.yaml:3-5` — analyzer plugin config includes `riverpod_lint: 3.1.3`

### External References

- [Flutter CLI docs](https://docs.flutter.dev/reference/flutter-cli) — official command-line reference; shows `flutter analyze` and `flutter test` as standard app-level verification commands and explicitly positions them as the normal Flutter CLI workflow.
- [Lefthook Hook configuration docs](https://lefthook.dev/configuration/Hook/) — official Lefthook hook syntax reference; relevant for how pre-commit/pre-push/commit-msg hooks are defined.
- [Lefthook `stage_fixed` docs](https://lefthook.dev/configuration/stage_fixed/) — official note that `stage_fixed: true` only works for `pre-commit`, which is directly relevant for auto-formatting staged Dart files.
- [Lefthook `stage_fixed` example](https://lefthook.dev/examples/stage_fixed/) — official example showing the intended workflow for auto-fixing and re-staging files during `pre-commit`.
- [lefthook_dart package docs](https://pub.dev/packages/lefthook_dart) — Dart/Flutter-specific wrapper examples; shows staged-file formatting in `pre-commit` and broader `flutter analyze` / `flutter test` style checks in later hooks.
- [Git hooks in Flutter projects with Lefthook](https://dev.to/arthurdenner/git-hooks-in-flutter-projects-with-lefthook-52n) — concrete Flutter example that puts formatting on `pre-commit` and `flutter analyze` + `flutter test` on `pre-push`.
- [How to prevent bad commits and test code with lefthook and integrate with Flutter](https://dev.to/matteuus/how-to-prevent-bad-commits-and-test-code-with-lefthook-and-integrate-with-flutter-1ni4) — Flutter example showing `pre-commit`, `pre-push`, and `commit-msg`; useful as evidence that teams often use `commit-msg` for conventional-commit enforcement.
- [Validating commit messages with Dart and Lefthook](https://dev.to/remejuan/validating-commit-messages-with-dart-and-lefthook-9de) — Flutter/Dart-specific example of using a Dart script in `commit-msg` to validate commit messages from `.git/COMMIT_EDITMSG`.

### Convention Summary

#### What teams typically keep in `pre-commit`

Common pattern across Lefthook + Flutter/Dart examples:

- Keep `pre-commit` fast.
- Prefer staged-file-only operations.
- Use auto-fixers that can re-stage files.

Typical `pre-commit` choices:

- `dart format {staged_files}` or equivalent staged-file formatting
- optionally lightweight file-scoped fixers/lints on staged Dart files
- avoid full-repo test suites unless the repo is very small or the team explicitly accepts slower commits

Evidence:

- Official Lefthook docs support this pattern with `stage_fixed: true` for `pre-commit` auto-fixes.
- `lefthook_dart` example uses staged Dart file formatting in `pre-commit`.
- Flutter community Lefthook example places formatting in `pre-commit` and reserves heavier checks for later.

#### What teams typically keep in `pre-push`

Common pattern:

- Run broader, slower verification before code leaves the local machine.
- Execute checks in parallel when possible.

Typical `pre-push` choices:

- `flutter analyze`
- `flutter test` (often the repo’s unit/widget suite)
- sometimes package-workspace variants such as `melos exec -- flutter analyze`

Evidence:

- Flutter Lefthook example on DEV runs `flutter analyze` and `flutter test` in `pre-push`.
- `lefthook_dart` examples show broader analyze/test style commands in later hooks rather than in staged-file formatting hooks.
- Flutter official CLI docs treat `flutter analyze` and `flutter test` as standard project verification commands.

#### What teams typically keep in `commit-msg`

Common pattern:

- Use `commit-msg` for message policy only, separate from code-quality checks.

Typical `commit-msg` choices:

- conventional commit validation
- ticket/Jira key enforcement
- scope/verb regex enforcement

Evidence:

- Flutter/Dart Lefthook examples validate commit messages by reading `.git/COMMIT_EDITMSG` in a Dart script.
- Lefthook supports a dedicated `commit-msg` hook, so teams do not need to overload `pre-commit` with message validation.

#### What teams typically keep in CI

Common pattern:

- CI is the authoritative full-repo gate.
- CI re-runs checks even if hooks exist locally.
- CI usually avoids mutating commands and prefers verification mode.

Typical CI choices in Flutter apps:

- dependency install (`flutter pub get`)
- formatting verification (for example `dart format --output=none --set-exit-if-changed .` or project equivalent)
- `flutter analyze`
- full `flutter test`
- optionally integration tests and/or build verification

Reason this split is common:

- local `pre-commit` needs to stay quick enough for frequent use
- `pre-push` can tolerate heavier checks because it runs less often
- CI remains the final source of truth and catches skipped hooks or environment differences

### Practical Distribution Observed in Sources

| Stage | Typical Flutter/Dart checks | Why teams place them there |
|---|---|---|
| `pre-commit` | staged-file `dart format`, optional auto-fix on changed Dart files | fast feedback; can auto-stage fixes; minimal commit friction |
| `commit-msg` | conventional commit / ticket pattern validation | isolated policy check tied to commit message file |
| `pre-push` | `flutter analyze`, `flutter test` | broader correctness checks before sharing changes |
| `CI` | format verification, `flutter analyze`, full tests, integration/build checks | authoritative, reproducible, full-repo enforcement |

### Related Specs

- `.trellis/spec/frontend/quality-guidelines.md` — project quality spec already requires `flutter analyze` and targeted `flutter test` for logic changes.
- `.trellis/spec/frontend/index.md` — frontend spec index for related client-side conventions.

## Caveats / Not Found

- No existing `lefthook.yml` or related hook config was found in this repository at the time of research.
- The strongest authoritative sources here are Flutter CLI docs and Lefthook docs; Flutter-specific hook placement conventions are inferred from multiple community examples rather than from a single official Flutter policy document.
- Community examples differ on whether `flutter analyze`/`flutter test` run in `pre-commit` or `pre-push`, but the recurring split is: fast staged-file formatting in `pre-commit`, broader analyze/test in `pre-push` and CI.
