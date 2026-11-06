# 0002 — Claude Code is the agent runtime; the engine and gates work without it

## Context

Most of a modernization's discovery and planning is reading and writing: thousands of Delphi units to read, business
rules to extract with evidence, requirements, architecture assessments, ADRs and plans to draft. The governance diagram
assigns that work to a Principal Architect and six workstreams. Those roles can be filled by people, by AI agents, or
by both.

Building an agent loop into the studio would mean reimplementing file tools, permissions, sub-agents, budgets, session
resume and model access, and keeping up with them. The Claude Code CLI already provides all of it, runs headless
(`claude -p --output-format stream-json`), reads project agents and skills from `.claude/`, enforces permission rules
and hooks, and caps spend per run.

## Decision

The kit defines the seven roles as Claude Code sub-agents with skills and permission rules. The engine's runner launches
the user's installed `claude` CLI headless in the workspace and parses its event stream; the studio shows runs live,
records transcripts and cost, and can stop a run. Authentication and billing stay with the user's own Claude account;
nothing in the product stores a key.

Agents draft; they never decide. Permission rules and the engine's guard hook stop them from editing `legacy/`,
recording approvals, or changing anything outside `docs/` before gate G4. Every claim they write carries an evidence
link and a Confirmed, Inferred, Assumption or Unknown label, and the traceability checker verifies the links.

## Consequences

The engine, the gates, the templates and the traceability checker work with no AI. `AGENTS.md` makes the same
workspace usable with other assistants by hand; only the in-app runner is Claude-specific. The runner depends on the
CLI's flags and event format, so it checks a minimum CLI version and keeps unknown event types instead of failing on
them.
