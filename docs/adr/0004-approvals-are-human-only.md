# 0004 — Only a person approves a gate, and the approval is bound to a commit

## Context

The brief forbids implementation until the planning baseline is reviewed and explicitly approved. With agents able to
edit files, "approved" must mean something an agent cannot produce, and it must identify exactly which version of the
documents was approved.

## Decision

Gates G0–G4 are approved only through the studio's approval dialog or by a person running `dmz approve <gate>`. An
approval appends to `.modernizer/approvals.json` the gate, the approver from git configuration, the time, a note and
the git tree hash of `docs/` at that moment, adds a DEC- entry to the decision log, and commits both.

Agents are kept out by three independent layers: the workspace's `.claude/settings.json` denies writes to
`.modernizer/approvals.json`; the guard hook (`dmz guard pre-tool-use`) refuses `dmz approve` from an agent and refuses
writes outside `docs/` before G4; and the engine treats an approval whose recorded tree hash no longer matches the
approved commit's `docs/` as stale.

## Consequences

An approval is evidence of what was approved, not only that something was. Changing an approved deliverable makes the
approval stale, which the studio shows and which blocks the next gate until a person approves again. The approver's
identity is as trustworthy as the repository's commit identity; teams that need stronger guarantees use signed commits
and branch protection on the workspace repository.
