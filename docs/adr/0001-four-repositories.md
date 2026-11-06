# 0001 — The product is four repositories: kit, engine, studio and this one

## Context

The product has three parts that change for different reasons. The methodology — deliverable templates, the ID
grammar, gate criteria, agent roles — changes when the way a modernization is governed changes, and teams can use it
with no tooling at all. The engine — scanner, traceability checker, gates, agent runner — changes when the analysis
improves, and runs anywhere .NET runs, including CI. The studio changes when the user experience changes, and builds
only on Windows.

kakehashi keeps its CLI in the same repository as its template (its ADR 0019) because the generator and the code it
generates must change together. The same argument applies between the engine and the kit: the engine parses what the
kit's spec defines. It does not apply between the methodology and the app, which share no code.

## Decision

Four repositories under `delphi-modernizer`: `kit` (methodology and spec, no product code), `engine` (cross-platform
libraries and the `dmz` CLI), `studio` (the WinUI 3 app) and `.github` (organization defaults, standards and reusable
workflows). Dependencies point one way: kit → engine → studio.

The version boundary kakehashi avoids is made explicit instead. The engine pins one kit commit or tag in
`kit.lock.json` and embeds that kit at build time; the studio pins one engine version. Each lock is changed by a pull
request whose CI runs the dependent repository's full gates against the new version.

## Consequences

The methodology is usable, versioned and reviewable without the app, and the engine's CI runs on Linux without a
Windows runner. A change that spans the kit and the engine takes two pull requests in order — kit first, then the
engine's lock bump — and the engine's tests are what catch a spec change the parser does not follow. Shared
conventions cannot drift silently because `standards-drift` compares each repository's copies with the ones here.
