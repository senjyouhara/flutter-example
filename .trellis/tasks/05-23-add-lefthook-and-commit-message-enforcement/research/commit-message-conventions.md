# Research: commit-message-conventions

- **Query**: Research practical commit message enforcement conventions for application repositories, comparing Conventional Commits against lightweight custom formats, with attention to local git hook enforcement and CI parity.
- **Scope**: mixed
- **Date**: 2026-05-23

## Findings

### Files Found

| File Path | Description |
|---|---|
| `.trellis/tasks/05-23-add-lefthook-and-commit-message-enforcement/task.json` | Active planning task for adding Lefthook and commit message enforcement. |
| `.trellis/spec/guides/index.md` | General project thinking-guide index; no commit-message-specific guidance found. |

### Code Patterns

- Repository search did not find existing `lefthook`, `commitlint`, `commit-msg`, or `Conventional Commits` configuration in tracked project files.
- Active task metadata confirms the current task is specifically about hook-based enforcement:
  - `.trellis/tasks/05-23-add-lefthook-and-commit-message-enforcement/task.json:2-4`
    ```json
    "id": "add-lefthook-and-commit-message-enforcement",
    "name": "add-lefthook-and-commit-message-enforcement",
    "title": "add lefthook and commit message enforcement"
    ```
- `.trellis/spec/guides/index.md` is general-purpose only; no repo-local convention for commit messages or hook policy was found.

### External References

- [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) — official specification. Core required shape is `type[(scope)][!]: description`; `feat` and `fix` are semantically meaningful, `BREAKING CHANGE:` or `!` signals a breaking change. The spec explicitly allows additional types beyond `feat`/`fix`.
- [commitlint local setup guide](https://commitlint.js.org/guides/local-setup) — official guidance for linting commit messages at author time via Git hooks; directly relevant for short local feedback loops.
- [commitlint configuration reference](https://commitlint.js.org/reference/configuration.html) — documents both stock Conventional Commits enforcement and customization paths. Relevant details:
  - `extends: ["@commitlint/config-conventional"]` enables the standard Conventional Commits rule set.
  - `rules` can narrow or widen allowed types.
  - `parserPreset`, `headerPattern`, and `headerCorrespondence` allow non-standard lightweight formats to be linted as long as the format is still machine-parseable.
  - `defaultIgnores: true` means merge/revert/semver-style messages are ignored unless explicitly disabled.
- [@commitlint/config-conventional README](https://github.com/conventional-changelog/commitlint/blob/master/%40commitlint/config-conventional/README.md) — shows the default type set commonly enforced in practice: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`.
- [commitlint CI setup guide](https://commitlint.js.org/guides/ci-setup.html) — official CI parity reference. GitHub Actions example uses:
  - `fetch-depth: 0`
  - `npx commitlint --last --verbose` on `push`
  - `npx commitlint --from <base-sha> --to <head-sha> --verbose` on `pull_request`
  This is the clearest official pattern for matching local enforcement with server-side validation.
- [Lefthook README](https://github.com/evilmartians/lefthook/blob/master/README.md) — official hook manager reference. Documents `lefthook install` for creating hooks and `lefthook run <hook>` for direct execution.
- [Lefthook run configuration docs](https://github.com/evilmartians/lefthook/blob/master/docs/configuration/run.md) — important for `commit-msg` hooks. The docs note that `commit-msg` receives a single argument: the path to the temporary commit message file, exposed as `{1}` in Lefthook command templates.
- [Lefthook scripts docs](https://lefthook.dev/configuration/Scripts/) — official example of lightweight custom enforcement via a shell script. Example pattern:
  - read the first line from the commit message file
  - validate against a regex such as `^(TICKET)-[[:digit:]]+: `
  - exit non-zero to block the commit
  This is the most direct official example of a custom, non-Conventional-Commits policy enforced with Lefthook.

### Practical Convention Comparison

#### 1. Conventional Commits

Observed characteristics from the official spec and commitlint docs:

- Strongly structured: `type(scope): subject`
- Best when commit messages are expected to drive automation such as changelog generation, SemVer release inference, or commit categorization.
- Works out of the box with `@commitlint/config-conventional`, so local hook and CI enforcement can share the same config with little custom logic.
- Supports some flexibility without abandoning the standard, because extra types are allowed and commitlint rules can customize `type-enum`.
- The specification FAQ notes it is not mandatory for every intermediate developer commit if a squash-based merge workflow is used; maintainers can normalize the final merge commit message.

Practical enforcement shape:

- Local: `commit-msg` hook runs commitlint against the proposed message file.
- CI: run commitlint on the pushed commit or full PR commit range.
- Parity: highest when the same commitlint config is used both locally and in CI.

#### 2. Lightweight custom formats

Common practical shape from Lefthook script examples and commitlint configurability:

- Lower ceremony than Conventional Commits.
- Usually enforces one or two rules only, such as:
  - ticket prefix (`ABC-123: subject`)
  - imperative subject line
  - max header length
  - no placeholder text such as `update` or `fix stuff`
- Can be implemented in two main ways:
  1. A simple Lefthook shell script with a regex against the message file.
  2. commitlint with a custom parser/ruleset instead of `@commitlint/config-conventional`.
- Better fit when the repository is an application repo that mainly wants consistency/readability rather than release automation semantics.

Practical enforcement shape:

- Local: `commit-msg` hook validates the first line or entire message with regex/script logic.
- CI: the same script or the same linting tool must run over the commit range; otherwise developers can bypass local hooks.
- Parity: only reliable if the custom rule implementation is reusable in CI instead of duplicated manually.

### Local Hook Enforcement and CI Parity

Across the official docs, the repeatable pattern is:

1. Enforce at `commit-msg`, not `pre-commit`, because commit text is only available after Git writes the temporary message file.
2. Use one parsing/linting definition for both local and CI checks.
3. In CI, validate the full PR commit range rather than only the merge result if the repository cares about every individual commit.
4. For GitHub Actions, full history (`fetch-depth: 0`) is required for range-based commitlint checks.
5. Local hooks improve feedback speed but are not sufficient by themselves because hooks can be skipped or not installed; CI provides the authoritative gate.

### Related Specs

- `.trellis/spec/guides/index.md` — general thinking-guide index; no commit-message or hook-specific contract found.

## Caveats / Not Found

- No existing repo-local commit message convention or hook configuration was found in the searched project files.
- No repo-local spec document under `.trellis/spec/` currently defines commit message format, git hook policy, or CI enforcement rules.
- External findings are based on official documentation and official repository docs surfaced through search results; they were not derived from an already-installed toolchain in this repository.
