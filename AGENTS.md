# delphi-modernizer/.github: working rules

This repository holds organization defaults, engineering standards and reusable workflows. It holds no product code.
These rules apply to people and AI agents alike.

## How to work

1. **Think before changing.** A file here is a default for every repository in the organization, or a workflow every
   repository calls. State which repositories a change affects and whether it is breaking for their CI.
2. **Minimum change.** No new workflow inputs, scripts or options that a calling repository does not need.
3. **Surgical changes.** Touch only what the request requires; mention unrelated problems instead of fixing them.
4. **Canonical files are copied verbatim.** `COMMENTS.md` and everything under `standards/` are compared byte for byte
   with each repository's copy by `standards-drift`. Changing one means updating every repository in the same sweep.
5. **Comments** follow [COMMENTS.md](COMMENTS.md).

## Workflows

- Third-party actions are pinned by commit SHA with a `# vX.Y.Z` comment; Dependabot updates them.
- Every workflow declares the narrowest `permissions` it needs.
- Values from inputs reach shell steps through `env:`, never by interpolating `${{ }}` into a script.

## Gates

All must pass before a change is done:

```bash
shellcheck scripts/*.sh
bash scripts/test-comment-lint.sh
bash scripts/comment-lint.sh .
actionlint
yamllint --strict .
markdownlint-cli2
```

## Process

Gitflow and Conventional Commits, as in [CONTRIBUTING.md](CONTRIBUTING.md).
