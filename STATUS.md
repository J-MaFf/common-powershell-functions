# STATUS

## What This Is

A small collection of standalone PowerShell utility scripts for everyday Windows administration tasks. Each script is self-contained; there is no module manifest and no shared code.

## Current State — 2026-08-10

CI is in place: every PR and push to `main` is validated (parse check + PSScriptAnalyzer) on the self-hosted Windows runner. The lint steps now live in the shared reusable workflows in [J-MaFf/.github](https://github.com/J-MaFf/.github); the required status check is `validate / ps-lint` (the Main Branch Ruleset was updated to match). The scripts themselves are unchanged and have no automated tests.

### Components

| File | Description |
| --- | --- |
| `Clear-PrintSpooler.ps1` | Restarts the print spooler service; self-elevates via UAC and prompts interactively. Never run in CI. |
| `add-script-to-path.ps1` | Adds a given path to the user or system `PATH` environment variable. Permanently mutates PATH; never run in CI. |
| `.github/workflows/windows-tests.yml` | CI: the `validate` job calls the shared reusable `ps-lint.yml` in [J-MaFf/.github](https://github.com/J-MaFf/.github) (parse check + PSScriptAnalyzer, fails on Error severity only) on the self-hosted Windows runner; check reports as `validate / ps-lint`. |
| `.github/workflows/claude.yml` | Claude Code GitHub action, triggered by `@claude` mentions; thin caller of the shared reusable `claude.yml` in [J-MaFf/.github](https://github.com/J-MaFf/.github). |

### Resolved Issues

| Issue | Description | PR |
| --- | --- | --- |
| [#5](https://github.com/J-MaFf/common-powershell-functions/issues/5) | Add Windows CI (parse check + PSScriptAnalyzer) on the self-hosted runner | [#6](https://github.com/J-MaFf/common-powershell-functions/pull/6) |
| [#7](https://github.com/J-MaFf/common-powershell-functions/issues/7) | Adopt shared reusable workflows (`claude.yml`, `ps-lint.yml`) from J-MaFf/.github | [#8](https://github.com/J-MaFf/common-powershell-functions/pull/8) |

### Open Issues

| Issue | Description |
| --- | --- |
| [#4](https://github.com/J-MaFf/common-powershell-functions/issues/4) | Adopt beads (bd) for AI task tracking |

## Natural Next Steps

- Add Pester tests for the pure logic (e.g. the PATH-membership check in `add-script-to-path.ps1`) and wire them into the CI workflow
- Refactor the interactive/elevating parts of `Clear-PrintSpooler.ps1` behind parameters so the core logic is testable
- Expand `readme.md` to document `Clear-PrintSpooler.ps1`

## Prerequisites to Run

- Windows with PowerShell 5.1+ (PowerShell 7+ preferred)
- Administrator rights for `Clear-PrintSpooler.ps1` (it self-elevates) and for system-scope PATH changes in `add-script-to-path.ps1`
- Clone the repo and run the scripts directly; there is nothing to install
