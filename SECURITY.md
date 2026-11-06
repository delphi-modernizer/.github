# Security policy

Report vulnerabilities privately through GitHub's **Report a vulnerability** button on the affected repository's
Security tab. Do not open public issues for security problems.

Reports about these areas have the highest priority:

- the gate guard and approval records, which decide when agents may change code;
- secret redaction in scanner output;
- how the engine launches the Claude Code CLI and other processes;
- path handling that could read or write outside a workspace.

Only the latest release receives fixes until 1.0.
