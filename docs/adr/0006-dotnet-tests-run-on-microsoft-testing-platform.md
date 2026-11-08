# 0006 — .NET tests run on Microsoft.Testing.Platform

## Context

`xunit.v3` 4.x runs on Microsoft.Testing.Platform 2, and the .NET 10 SDK refuses to run that through VSTest. Every .NET
repository here (the engine, the studio and the kit's .NET quality baseline) ran its tests through VSTest with
`Microsoft.NET.Test.Sdk`, `xunit.runner.visualstudio` and `coverlet.collector`, so the engine pinned xunit 3.x in its
ADR 0004 and Dependabot's 4.x updates could not pass. Staying on 3.x means the test framework stops receiving updates;
moving one repository alone breaks the shared `dotnet-ci` for the others.

The candidates for coverage on Microsoft.Testing.Platform are `coverlet.MTP` and Microsoft's
`Microsoft.Testing.Extensions.CodeCoverage`. Only coverlet writes OpenCover, the format Sonar's C# analysis already
reads here, and it is the same coverlet the repositories used.

## Decision

Every .NET repository sets `"test": { "runner": "Microsoft.Testing.Platform" }` in `global.json`. Test projects
reference `xunit.v3` and `coverlet.MTP` only; `Microsoft.NET.Test.Sdk`, `xunit.runner.visualstudio` and
`coverlet.collector` are removed. `dotnet-ci` runs `dotnet test` with `--coverlet --coverlet-output-format opencover`,
and Sonar reads `TestResults/**/coverage.opencover*.xml`, one file per test module.

## Consequences

The command lines in each repository's gates stay as they were: `dotnet test <solution> -c Release --no-build` works in
both modes. A repository still on VSTest fails `dotnet-ci`'s Test step once it moves its pin past this change, so the
engine, the studio and the kit move in one sweep. Visual Studio's Test Explorer runs the tests through
Microsoft.Testing.Platform, without the VSTest adapter. This supersedes the engine's ADR 0004.
