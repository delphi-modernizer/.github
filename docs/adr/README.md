# Architecture Decision Records

Decisions that span more than one repository. A decision inside one repository lives in that repository's
`docs/adr/`. One decision per file: Context → Decision → Consequences, in the shape kakehashi uses:

```markdown
# 0006 — The decision, as a sentence in the present tense

## Context
## Decision
## Consequences
```

No `Date:` or `Status:` line; git records both. Records are immutable once accepted; a reversal is a new record that
supersedes the old one.

| # | Decision |
| --- | --- |
| [0001](0001-four-repositories.md) | The product is four repositories: kit, engine, studio and this one |
| [0002](0002-claude-code-is-the-agent-runtime.md) | Claude Code is the agent runtime; the engine and gates work without it |
| [0003](0003-markdown-with-ids-is-the-source-of-truth.md) | A workspace is Markdown with IDs in git, not a database |
| [0004](0004-approvals-are-human-only.md) | Only a person approves a gate, and the approval is bound to a commit |
| [0005](0005-packages-are-published-to-github-packages.md) | Packages are published to GitHub Packages |
| [0006](0006-dotnet-tests-run-on-microsoft-testing-platform.md) | .NET tests run on Microsoft.Testing.Platform, with coverlet for coverage |
