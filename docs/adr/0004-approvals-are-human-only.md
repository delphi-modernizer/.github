# 0004 — Only a person approves a gate, and the approval is bound to a commit

## Context

The brief forbids implementation until the planning baseline is reviewed and explicitly approved. With agents able to
edit files, "approved" must mean something an agent cannot produce, and it must identify exactly which version of the
documents was approved.

## Decision

Gates G0–G4 are approved only through the studio's approval dialog or by a person running `dmz approve <gate>`. An
approval appends an entry to `.modernizer/approvals.json`: the gate, the approver from git configuration, the time, a
note, the current commit, and a SHA-256 content hash over the gate's deliverable files (as the kit's `spec/` defines
it). Approved is never a front-matter value; it is derived from that record.

Agents are kept out by independent layers: the workspace's `.claude/settings.json` denies edits to `.modernizer/` and
`legacy/`, and allows `dmz` only for read and check commands; the guard hook (`dmz guard pre-tool-use`) refuses
`dmz approve` and any edit outside `docs/` and, after G4, `target/`; and the hook fails closed when `dmz` is missing.
An approval whose content hash no longer matches the gate's files is stale.

## Consequences

An approval is evidence of what was approved, not only that something was. Changing an approved deliverable makes the
approval stale, which the studio shows and which blocks the next gate until a person approves again. Because the hash
covers only the gate's own files, work on later deliverables does not disturb earlier approvals. The approver's
identity is as trustworthy as the repository's commit identity; teams that need stronger guarantees use signed commits
and branch protection on the workspace repository.
