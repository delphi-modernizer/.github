# delphi-modernizer/.github

Organization-level files for [Delphi Modernizer](https://github.com/delphi-modernizer). Nothing here is product code.

| Path | Purpose |
| --- | --- |
| [profile/README.md](profile/README.md) | The organization's landing page |
| [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md), [SUPPORT.md](SUPPORT.md) | Defaults for every repository that has no file of its own |
| [.github/ISSUE_TEMPLATE](.github/ISSUE_TEMPLATE), [.github/pull_request_template.md](.github/pull_request_template.md) | Default issue forms and pull-request template |
| [COMMENTS.md](COMMENTS.md) | The comment convention, copied verbatim into every repository |
| [standards/](standards/STANDARDS.md) | Engineering standards and the canonical files the drift check compares against |
| [scripts/](scripts) | `comment-lint.sh` and `standards-drift.sh`, run by the reusable workflows |
| [.github/workflows](.github/workflows) | Reusable workflows: `comment-lint`, `standards-drift`, `dotnet-ci`, `java-ci`, `dependency-review`, `pr-title` |
| [workflow-templates/](workflow-templates) | Starter workflows offered when a repository in the organization adds a workflow |
| [docs/](docs/ARCHITECTURE.md) | How the repositories fit together, and the organization-wide ADRs |

## Calling a reusable workflow

```yaml
jobs:
  comments:
    uses: delphi-modernizer/.github/.github/workflows/comment-lint.yml@main
  build:
    uses: delphi-modernizer/.github/.github/workflows/dotnet-ci.yml@main
    with:
      solution: Example.slnx
      os: '["ubuntu-latest", "windows-latest"]'
    secrets:
      SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

## Checks

```bash
shellcheck scripts/*.sh
bash scripts/test-comment-lint.sh
bash scripts/comment-lint.sh .
actionlint
yamllint --strict .
markdownlint-cli2
```
