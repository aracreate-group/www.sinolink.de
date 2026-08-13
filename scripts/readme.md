# SCRIPTS

Helper scripts for the project.

- `motd` — the ANSI Shadow banner printed by `make help`.
- `check-assets.sh` — resolves every `src`, `href`, `url(...)` and video path
  referenced from `src/` against the filesystem, so a renamed or missing asset
  is caught before deploy. Run via `make test`.
