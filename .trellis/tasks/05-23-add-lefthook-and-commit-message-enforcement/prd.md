# add lefthook and commit message enforcement

## Goal

为当前 Flutter 项目接入 Lefthook，并建立可执行的 Git commit message 规范，让本地提交前校验与后续 CI 校验保持一致，减少低质量提交和不可读 commit 历史。

## What I already know

* 仓库当前没有 `lefthook.yml`、`commitlint`、`commit-msg` hook 或 GitHub Actions workflow。
* `pubspec.yaml` 已有 `flutter_test`、`flutter_lints`、`riverpod_lint`，说明 `flutter analyze` 是现成的质量入口。
* 当前仓库没有 `test/` 或 `integration_test/` 目录。
* `.trellis/spec/frontend/quality-guidelines.md` 已要求逻辑改动至少跑 `flutter analyze`，并在有测试或逻辑较重时跑定向 `flutter test`。
* 外部实践显示 Flutter/Dart + Lefthook 的常见分层是：`pre-commit` 做快速 staged format，`commit-msg` 校验提交信息，`pre-push` 和 CI 跑 `flutter analyze` / `flutter test`。
* 外部实践显示如果要保证本地与 CI 一致，commit message 最稳妥的方案是 `commit-msg` 本地校验 + CI 校验完整 commit range。

## Assumptions (temporary)

* 这次改造会同时引入本地 hook 配置和后续可复用的 CI 校验入口。
* `pre-commit` 应优先保持快速，不在当前仓库直接跑全量测试。
* commit message 规范需要机器可校验，而不是只写文档约定。

## Open Questions

* 暂无。

## Requirements (evolving)

* 引入 Lefthook 作为本地 Git hooks 管理器。
* commit message 采用 Conventional Commits，并可被机器校验。
* 为代码校验和 commit message 校验提供明确的 hook 分层。
* 保证本地校验入口与 CI 可复用，避免两套不一致逻辑。
* 保持本地提交流程足够快，不把明显慢命令放进 `pre-commit`。
* 除规则校验外，仓库内还要提供简短 commit message 示例/说明，帮助团队快速写对。

## Acceptance Criteria (evolving)

* [ ] 仓库新增可执行的 Lefthook 配置。
* [ ] 提交信息在本地 `commit-msg` 阶段会按 Conventional Commits 被机器校验。
* [ ] 格式化、分析、测试校验职责被清晰拆到合适的 hook / CI 阶段。
* [ ] 仓库提供团队可遵循的 Conventional Commits 示例/说明。
* [ ] 后续 CI 可以复用同一套规则，而不是人工重复维护。

## Definition of Done (team quality bar)

* Tests added/updated (unit/integration where appropriate)
* Lint / typecheck / CI green
* Docs/notes updated if behavior changes
* Rollout/rollback considered if risky

## Out of Scope (explicit)

* 本次不引入与提交规范无关的发布自动化。
* 本次不重构业务代码。
* 本次不在没有测试资产的前提下补一整套测试体系。

## Technical Notes

* 相关仓库文件：`pubspec.yaml`、`analysis_options.yaml`、`.trellis/spec/frontend/quality-guidelines.md`
* 研究文件：
  * `research/pre-commit-conventions.md`
  * `research/commit-message-conventions.md`
* 已确认方向：commit message 采用 Conventional Commits，本地 `commit-msg` 与 CI commit range 校验复用同一套规则。
* 初步推荐分层：
  * `pre-commit`: staged-file `dart format`
  * `commit-msg`: Conventional Commits 校验
  * `pre-push`: `flutter analyze`，必要时 `flutter test`
  * `CI`: format verify + `flutter analyze` + tests + commit range 校验
