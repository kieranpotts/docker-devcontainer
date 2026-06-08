# Changelog

## [Unreleased]

- Pin the dotfiles version via the `DOTFILES_VERSION` build arg (the `--dotfiles` option on `./run/build`), instead of always tracking the `dev` branch.
- Renamed the bootstrap version option on `./run/build` from `-v` to `--bootstrap`.

## [1.4.0] - 2026-05-15

- Upgrade to kieranpotts/bootstrap:v1.2.0.

## [1.3.0] - 2026-04-07

- Renamed container from `kieranpotts/devenv` to `kieranpotts/devcontainer`.
- Switched to non-root user named `code`.

## [1.2.0] - 2026-04-06

- Added SSH clients.
- Changed bootstrap scripts.

## [1.1.0] - 2026-04-05

- Added dotfiles.

## [1.0.0] - 2026-03-20

- Initial build.
