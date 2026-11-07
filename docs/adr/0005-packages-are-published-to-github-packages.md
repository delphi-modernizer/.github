# 0005 — Packages are published to GitHub Packages

## Context

The studio consumes the engine as NuGet packages (ADR 0001). The two candidate feeds are nuget.org and GitHub
Packages. nuget.org needs no authentication to restore, but needs an account, an API key stored as a secret, and a
reserved package prefix. GitHub Packages needs no external account and publishes with the workflow's `GITHUB_TOKEN`,
but restoring requires authentication even for public packages.

## Decision

The engine publishes to `https://nuget.pkg.github.com/delphi-modernizer/index.json` from its release workflow. The
studio's CI restores with `GITHUB_TOKEN`, once the packages grant the `studio` repository read access. A developer
restores with a personal access token that has `read:packages`, configured once in their user-level NuGet settings.

Until the engine's first release, and whenever a developer works across both repositories, the studio builds the
engine from source with `-p:EngineSource=Source`, which needs no feed at all.

## Consequences

No account outside GitHub is needed to release. Contributors to the studio need a token or the engine source checked
out beside it, which the studio's README explains. If the project later wants anonymous restore, publishing the same
packages to nuget.org is an additive change to the engine's release workflow.
