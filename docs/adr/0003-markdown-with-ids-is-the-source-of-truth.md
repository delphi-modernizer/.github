# 0003 — A workspace is Markdown with IDs in git, not a database

## Context

The brief requires every requirement, decision, risk and test to be traceable, reviewable and recorded over time.
Those records are written by people and agents, reviewed in pull requests, and must outlive any tool version. A
database would give queries and constraints, but every edit would go through the app, reviews would happen outside
the team's normal process, and agents would need an API instead of files.

## Decision

A workspace is a folder, ideally its own private git repository. Deliverables are Markdown files with YAML
front-matter (`id`, `status`, `owner`). Records are defined by an ID in a heading (`### FR-012 — …`) or in the first
cell of a register table row, and referenced by that ID anywhere else. Evidence is a link into the legacy source with
a line range, `legacy/Path/Unit.pas#L120-L180`. The kit's `spec/` defines the grammar; the engine's traceability
checker enforces it and derives the matrix. Machine state that is not a deliverable — scan output, run transcripts,
approvals — lives under `.modernizer/` as JSON.

## Consequences

Every change is a diff a reviewer can read, history is git's, and any editor or agent can work on the files. What a
database would enforce on write — unique IDs, resolvable references, evidence that exists — is checked after the fact
by `dmz trace`, so a workspace can be temporarily inconsistent between checks, and gate G4 requires zero errors.
Because findings about a real system are sensitive, the studio warns when a workspace is not a private repository.
