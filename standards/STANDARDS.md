# Engineering standards

These rules apply to every `delphi-modernizer` repository and to the code the kit asks agents to write in a
modernization workspace after gate G4. Each rule names what enforces it. A rule enforced only by review says so.

## 1. Code explains itself

Names, types and small functions carry the meaning. A comment states a fact the code cannot show; see
[COMMENTS.md](../COMMENTS.md). Enforced by the `comment-lint` reusable workflow and by review.

## 2. One style per language, identical in every repository

| Language | Style | Enforced by |
| --- | --- | --- |
| C# | [csharp/csharp-style.md](csharp/csharp-style.md) and [csharp/.editorconfig](csharp/.editorconfig) | `dotnet format --verify-no-changes`, `EnforceCodeStyleInBuild`, KH0001–KH0007, `standards-drift` |
| Java | [java/JAVA-STYLE.md](java/JAVA-STYLE.md) (Google Java Style) and [java/.editorconfig](java/.editorconfig) | Spotless (google-java-format), Checkstyle `google_checks.xml` |
| Python | PEP 8, type hints, `ruff` defaults plus `I`, `UP`, `B`, `SIM` | `ruff format --check`, `ruff check` |
| Shell | `set -euo pipefail`, quoted expansions | `shellcheck` |
| PowerShell | `Set-StrictMode -Version Latest`, `$ErrorActionPreference = 'Stop'` | PSScriptAnalyzer |
| Workflows | pinned actions, least-privilege `permissions` | `actionlint`, review |
| Markdown | 120-column prose, one sentence per idea | `markdownlint-cli2` |

`standards-drift` fails a repository whose `.editorconfig`, `tests/.editorconfig`, `docs/COMMENTS.md` or
`docs/csharp-style.md` differs from the copy here.

## 3. Zero static-analysis issues

C# builds with `TreatWarningsAsErrors` and `AnalysisLevel=latest`, plus `SonarAnalyzer.CSharp`, so a Sonar, CA, IDE or
KH issue is a build error. Java builds fail on any Checkstyle or SpotBugs finding. No blanket suppressions: every rule a
repository disables or downgrades is listed in its `docs/analyzers.md` with the reason. When the `SONAR_TOKEN` secret
exists, CI also runs the SonarQube Cloud analysis and its quality gate.

## 4. Zero known vulnerabilities

| Ecosystem | Gate |
| --- | --- |
| NuGet | `NuGetAudit=true`, `NuGetAuditMode=all`, `NuGetAuditLevel=low`, with warnings as errors; CI runs `dotnet list package --vulnerable --include-transitive` and fails on any result |
| Maven | OSV-Scanner on `pom.xml`, transitive dependencies included; any finding fails |
| GitHub Actions | third-party actions pinned by commit SHA with a version comment |
| Pull requests | `dependency-review` with `fail-on-severity: low` |
| Continuous | Dependabot version and security updates, CodeQL code scanning |

## 5. Choices are evaluated in writing

Any non-obvious design pattern, algorithm, data structure or third-party dependency gets an ADR or a
`docs/design/` note before or with the code that embodies it. The note states the problem, the candidates, their time and
space complexity where it matters, the trade-offs, the decision and its consequences. A pattern needs a stated reason;
code that is used once gets no abstraction.

## 6. Tests

xUnit v3 and NSubstitute for C#; JUnit 5 for Java. MediatR, AutoMapper and FluentAssertions are not used. Behaviour is
tested through public surfaces; golden files cover parsers and generators. Coverage is collected (coverlet, JaCoCo) and
reported to Sonar.

## 7. Process

Gitflow: `main` holds releases, `development` integrates, work happens on `feature/`, `bugfix/`, `release/` and
`hotfix/` branches. Commits follow [Conventional Commits](https://www.conventionalcommits.org/) with the types `feat`,
`fix`, `refactor`, `docs`, `test`, `chore` and `ci`. Everything lands through a pull request with green CI. Each
repository's `AGENTS.md` lists its gate commands and applies to people and agents alike.

## 8. Carried into modernization workspaces

The kit's target packs (`targets/dotnet`, `targets/jvm`) carry a quality baseline with these same gates, and the
workspace `AGENTS.md` requires agents to meet them for every line of code they write after G4.
