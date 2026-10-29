# Changelog

## [Unreleased]

## [1.10.0] - 2026-10-29

- Add NVM's default Node.js version (`~/.nvm/current/bin`) to `PATH` in the
  image, so that `node` and `npm` are found outside interactive shells, too.
- Requires kieranpotts/bootstrap:v1.13.1, which maintains the `~/.nvm/current`
  symlink.

## [1.9.0] - 2026-10-29

- Upgrade to kieranpotts/bootstrap:v1.13.0.
- Upgrade to kieranpotts/dotfiles:v1.3.0.

## [1.8.0] - 2026-10-28

- Upgrade to kieranpotts/bootstrap:v1.12.1.
- Upgrade to kieranpotts/dotfiles:v1.3.0.
- Add `~/.local/bin` and mise's shims directory to `PATH` in the image, so that
  pipx tools, Poetry, and mise-managed tools are found outside interactive
  shells, too.
- Prompt for the bootstrap and dotfiles versions in `./run/build`, if they
  aren't set in the `BOOTSTRAP_VERSION` and `DOTFILES_VERSION` environment
  variables.

## [1.7.0] - 2026-08-12

- Upgrade to kieranpotts/bootstrap:v1.7.1.
- Upgrade to kieranpotts/dotfiles:v1.2.0.

## [1.6.0] - 2026-08-10

- Build the image with bootstrap's "CLI" toolset: `./run/install --profile=cli`.

## [1.5.0] - 2026-06-08

- Pin the dotfiles version via the `DOTFILES_VERSION` build arg, instead of
  always tracking the `dev` branch.
- Pass the target `BOOTSTRAP_VERSION` and `DOTFILES_VERSION` to `./run/build`
  as environment variables on the command line.
- Add pre-commit hooks.
- Various other maintenance tasks.

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
