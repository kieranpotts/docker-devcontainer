# Docker image for my development environment

This repository builds the Docker image used as the base for the devcontainer
for Kieran Potts' personal projects. The image is Debian slim plus the
configuration from the [bootstrap](https://github.com/kieranpotts/bootstrap)
scripts and a pinned release of [dotfiles](https://github.com/kieranpotts/dotfiles).
The built image is consumed by the devcontainer config in the
[workspace repository](https://github.com/kieranpotts/workspace).

The capitalized words REQUIRED, MUST, MUST NOT, RECOMMENDED, SHOULD,
SHOULD NOT, OPTIONAL, and MAY are to be interpreted as described in
[IETF RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

## Tech stack

- Docker (Debian slim base image).
- Make, wrapping thin Bash scripts under `run/`.
- pre-commit for commit-message validation, and GitHub Actions for CI
  (stale-issue flagging, commit-message validation, label sync).

## Project structure

- **[src/Dockerfile](./src/Dockerfile)** \
  The image definition. Installs the bootstrap and dotfiles configuration at
  build time, pinned to specific tags via build args. The bootstrap runs as
  `./run/install --profile=cli`, so the image gets only the bootstrap's
  "core" step set, not the full workstation install.

- **[run/build](./run/build)** \
  Builds the image from `src/Dockerfile`, reading `BOOTSTRAP_VERSION` and
  `DOTFILES_VERSION` from the environment.

- **[run/publish](./run/publish)** \
  Tags and pushes the built image to Docker Hub
  (`kieranpotts/devcontainer`), then logs out.

- **[CHANGELOG.md](./CHANGELOG.md)** \
  Release history, following Keep a Changelog / semantic versioning.

## Tools

- `make build` \
  Builds the image. Requires `BOOTSTRAP_VERSION` and `DOTFILES_VERSION`
  environment variables, matching tags in the `bootstrap` and `dotfiles`
  repositories respectively.

- `make publish` \
  Publishes the built image to Docker Hub. Requires `DOCKER_USERNAME` and
  `DOCKER_TOKEN` to be set, and the HEAD commit to be tagged with the release
  version being published.

## Rules

- MUST pin `BOOTSTRAP_VERSION` and `DOTFILES_VERSION` to real tags in their
  respective upstream repositories when building. The Dockerfile does not
  default to `latest`/`dev`.

- MUST use a `BOOTSTRAP_VERSION` tag that provides `./run/install` and its
  `--profile=cli` flag.

- SHOULD keep the image's tool set defined upstream, in the bootstrap
  repository's `core_step` call sites, rather than maintaining a second tool
  list here. Two lists would drift.

- MUST update `CHANGELOG.md` and tag the HEAD commit with the semantic
  version before running `make publish`, so the published image tag matches
  the Git tag.

- MUST NOT commit a Docker Hub access token. Treat it like a password.
  Regenerate immediately via Docker Hub account settings if one leaks.

## References

This project follows Kieran Potts' technical standards. Read the relevant
standard(s) below for the current task. Their RFC 2119 rules MUST be followed
unless explicitly overridden elsewhere in this file.

- **[TS-9: Version Control](https://kieranpotts.com/standards/009)**
- **[TS-11: Versioning](https://kieranpotts.com/standards/011)**
- **[TS-58: Docker](https://kieranpotts.com/standards/058)**
- **[TS-60: GitHub Actions](https://kieranpotts.com/standards/060)**
