# Delphi Modernizer

A governed path from a legacy Delphi codebase to a modern C#/.NET or Java system. Discovery and planning come first,
every claim carries evidence from the legacy source, and nothing is implemented until a person approves the
modernization baseline.

```mermaid
flowchart TB
    PA["Principal Architect<br/>governance · decisions · integration · quality gates"]
    PA --> WS1["WS01 Legacy Discovery"]
    PA --> WS2["WS02 Requirements"]
    PA --> WS3["WS03 Architecture"]
    PA --> WS4["WS04 Data & Integration"]
    PA --> WS5["WS05 Migration Planning"]
    PA --> WS6["WS06 Quality & Security"]
    WS1 & WS2 & WS3 & WS4 & WS5 & WS6 --> BL["Approved Modernization Baseline<br/>requirements · architecture · roadmap · quality gates"]
    BL --> IM["Implementation & Incremental Migration"]
```

| Repository | Contents |
| --- | --- |
| [kit](https://github.com/delphi-modernizer/kit) | The methodology: agent roles, deliverable templates D01–D20, the ID scheme, gates G0–G4 and the .NET and JVM target packs |
| [engine](https://github.com/delphi-modernizer/engine) | Cross-platform .NET libraries and the `dmz` CLI: Delphi scanner, traceability checker, workspace gates, agent runner |
| [studio](https://github.com/delphi-modernizer/studio) | The WinUI 3 desktop app that drives a modernization workspace |
| [.github](https://github.com/delphi-modernizer/.github) | Organization defaults, [engineering standards](https://github.com/delphi-modernizer/.github/blob/main/standards/STANDARDS.md) and reusable workflows |

The kit flows into the engine, and the engine into the studio. The engine and the gates work without any AI; Claude Code
agents are the optional workforce that drafts the deliverables, and people approve every gate.

Status: early development. MIT licensed.
