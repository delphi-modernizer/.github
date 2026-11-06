# Java style

The [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html) is the style. This page names
what enforces each part, so a reader knows which rules a build checks and which are review.

## Layout

| | |
| --- | --- |
| Indent | 2 spaces, +4 for continuation lines (§4.2, §4.5.2) |
| Column limit | 100 (§4.4) |
| Imports | no wildcards, static imports in one block, then non-static, ASCII order (§3.3) |
| Braces | K&R, always used even for single statements (§4.1) |
| One top-level class per file | §3.4.1 |
| Line endings | LF |

## Naming (§5)

| Identifier | Style |
| --- | --- |
| Packages | all lower case, no underscores: `com.example.billing` |
| Classes, records, enums, interfaces | `UpperCamelCase` nouns |
| Methods | `lowerCamelCase` verbs |
| Constants (`static final`, deeply immutable) | `UPPER_SNAKE_CASE` |
| Fields, parameters, locals | `lowerCamelCase` |
| Type variables | a single capital letter, optionally followed by a numeral, or a class-style name ending in `T` |

## Comments and Javadoc

[COMMENTS.md](../../COMMENTS.md) applies unchanged: comments state facts the code cannot show. Javadoc follows §7,
including its exception for self-explanatory members (§7.3.1), so `getName()` takes none. `//` above a declaration
fails `comment-lint`.

## Programming practices (§6)

- `@Override` whenever it is legal.
- A caught exception is never ignored silently: an empty catch block says why in a comment, except in tests where the
  exception variable is named `expected`.
- Static members are qualified with the class name, not an instance.
- No finalizers.

These are review items; Checkstyle and SpotBugs catch some of them, not all.

## Beyond style

| Concern | Tool | Gate |
| --- | --- | --- |
| Formatting | google-java-format via Spotless (`spotless:check`) | build fails on any diff |
| Style | Checkstyle with the bundled `google_checks.xml`, `violationSeverity=warning`, `failOnViolation=true` | build fails on any violation |
| Bugs | SpotBugs (`effort=Max`, `threshold=Low`) | build fails on any finding |
| Tests and coverage | Surefire + JaCoCo | build fails on test failure; coverage reported to Sonar |
| Sonar rules | SonarQube Cloud (`sonar-maven-plugin`) | quality gate when `SONAR_TOKEN` is set |
| Vulnerable dependencies | OSV-Scanner on the CycloneDX SBOM the build writes (`target/bom.json`), Dependabot, dependency review | any finding fails |

The [java-ci](../../.github/workflows/java-ci.yml) reusable workflow runs all of it.
