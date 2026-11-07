# Contributing to Delphi Modernizer

## Workflow

1. Open an issue, or pick one, and agree on the approach for anything larger than a fix.
2. Branch from `development` as `feature/<topic>` or `bugfix/<topic>`. A `hotfix/` branch starts from `main`.
3. Commit with [Conventional Commits](https://www.conventionalcommits.org/): `<type>: <subject>`, where the type
   is one of `feat`, `fix`, `refactor`, `docs`, `test`, `chore` or `ci`, and the subject is lower case, imperative,
   with no full stop. A breaking change adds `!` before the colon and explains itself in the body. Keep each commit
   to one logical change.
4. Open a pull request into `development` (or `main` for a hotfix, then back into `development`). CI must be green.

| Branch | Cut from | Merges into |
| --- | --- | --- |
| `feature/…`, `bugfix/…` | `development` | `development` |
| `release/…` | `development` | `main` and `development` |
| `hotfix/…` | `main` | `main` and `development` |

`main` holds released code, tagged `vX.Y.Z`. Neither `main` nor `development` accepts direct pushes.

## Code

- [Engineering standards](standards/STANDARDS.md) apply to every repository: self-explanatory code, one style per
  language, zero analyzer and Sonar issues, zero known vulnerabilities, and a written evaluation for every non-obvious
  design, algorithm or data-structure choice.
- Comments follow [COMMENTS.md](COMMENTS.md): facts the code cannot show, nothing else.
- Each repository's `AGENTS.md` lists its gate commands; it applies to people and AI agents alike.
- A decision that shapes more than one module is an ADR in that repository's `docs/adr/`.

## Licensing

Contributions are licensed under the MIT License. Do not contribute code, text or assets you cannot license that way.
