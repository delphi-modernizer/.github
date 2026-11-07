# Python style

The style is the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html). This page names what
enforces each part, so a reader knows which rules a build checks and which are left to review. The reference
implementation is [SekiroKenjii/etl-pipeline-boilerplate](https://github.com/SekiroKenjii/etl-pipeline-boilerplate):
its `pyproject.toml`, `.editorconfig` and CI are the model for every Python project here.

## Layout

| | |
| --- | --- |
| Indent | 4 spaces (pyink's `pyink-indentation = 4`) |
| Column limit | 80 (§3.2), for code, comments and docstrings |
| Formatter | [pyink](https://github.com/google/pyink) with `unstable = true`, so long strings split and brackets hug |
| Imports | isort with `profile = "google"`, one import per line, trailing commas in wrapped `typing` imports |
| Line endings | LF |

## Imports (§2.2)

- Import modules, not names: `from kit import spec`, then `spec.Gate`. The exceptions are `typing` and
  `collections.abc`.
- Every module starts with `from __future__ import annotations`.
- No relative imports.

## Naming (§3.16)

| Identifier | Style |
| --- | --- |
| Modules, packages, functions, methods, variables | `lower_with_under`; script files too, so `build_icon_font.py` |
| Classes, exceptions | `CapWords`; exceptions end in `Error` |
| Constants | `CAPS_WITH_UNDER` |
| Type parameters (PEP 695) | `T`, or `T` followed by a name: `TIn`, `TOut` |
| Internal | a leading `_` |

## Docstrings and comments

Docstrings follow §3.8, as the Python row of [COMMENTS.md](../../COMMENTS.md) says.

- A one-line summary ends with a period.
- `Args:`, `Returns:` or `Yields:`, and `Raises:` follow when they say more than the signature. Classes add
  `Attributes:`.
- Every public module, class and function has one. So does any function of 12 lines or more (pylint's
  `docstring-min-length`).
- Inside a body, a `#` comment states what the code cannot show, at most two lines.

## Programming practices

- Every function is fully typed. mypy runs in `strict` mode with `warn_unreachable`, and pyright runs in `standard`
  mode with `reportMissingTypeStubs = "error"`. Stubs for an untyped third-party library go in `typings/`.
- Exceptions end in `Error`.
- `except Exception` appears only at an isolation point, with a comment saying so.
- An unused argument of an interface method is deleted: `del context  # Unused.`
- Paths are `pathlib.Path`.
- Text files are opened with an explicit `encoding="utf-8"`.

## Tooling

Each project's `pyproject.toml` holds the tool settings, copied from the reference implementation's with only the
paths changed:

- `[tool.pyink]`, `[tool.isort]`;
- `[tool.pylint.*]`, after Google's pylintrc with `pylint.extensions.docparams`;
- `[tool.mypy]`, `[tool.pyright]`;
- `[tool.pytest.ini_options]`, `[tool.coverage.*]`.

`.python-version` names the interpreter (3.14). The tools sit in `[dependency-groups]`, `uv.lock` is committed, and CI
runs `uv sync --frozen`.

| Check | Command | Enforced by |
| --- | --- | --- |
| Formatting | `uv run isort --check-only <sources>` and `uv run pyink --check <sources>` | `python-ci` |
| Lint | `uv run pylint <sources>`; tests and scripts with the reference's relaxed flags | `python-ci` |
| Types | `uv run mypy` and `uv run pyright` | `python-ci` |
| Tests | `uv run pytest` with `--strict-config --strict-markers`, `xfail_strict` and warnings as errors | `python-ci` |
| Known vulnerabilities | `pip-audit` on the hashed `uv export` of every group | `python-ci` |
| Insecure code | `bandit`; a finding that is not an issue is marked `# nosec <test>` with the reason | `python-ci` |
