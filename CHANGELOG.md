# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- `claude.yml` and the Windows lint steps in `windows-tests.yml` now call the shared reusable workflows in [J-MaFf/.github](https://github.com/J-MaFf/.github) instead of carrying their own copies; the required status check was renamed from `validate` to `validate / ps-lint` and the Main Branch Ruleset updated to match ([#8](https://github.com/J-MaFf/common-powershell-functions/pull/8))

### Added

- Added Windows CI workflow (`.github/workflows/windows-tests.yml`) that parse-checks every PowerShell script and runs PSScriptAnalyzer (failing on Error severity only) on the self-hosted Windows runner ([#5](https://github.com/J-MaFf/common-powershell-functions/issues/5), [#6](https://github.com/J-MaFf/common-powershell-functions/pull/6))
- Added `STATUS.md` and `CHANGELOG.md` project documentation ([#6](https://github.com/J-MaFf/common-powershell-functions/pull/6))
