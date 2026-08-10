# Docker image for my development environment

This repository builds a Docker container image for the development environment
I use for my personal projects.

The image is based on Debian slim and it contains the agent-profile tool set
from my [bootstrap scripts](https://github.com/kieranpotts/bootstrap) — the
minimal tooling a coding agent needs to work unattended in a container, rather
than the full workstation install.

The image is used as a base for my devcontainer, which is configured in the
[workspace repository](https://github.com/kieranpotts/workspace).

## Documentation

### Requirements

- Docker
- Make
- Git

### Prerequisites

Make the `run/*` scripts executable:

```sh
chmod +x run/*
```

### Building

The target versions are passed in on the command line via the `BOOTSTRAP_VERSION`
and `DOTFILES_VERSION` environment variables. `BOOTSTRAP_VERSION` MUST match a
tag in the `kieranpotts/bootstrap` repository, and `DOTFILES_VERSION` MUST match
a tag in the `kieranpotts/dotfiles` repository.

The build runs `./run/install --profile=agent` from the bootstrap repository,
which installs only the minimal tool set a coding agent needs in a headless
container. `BOOTSTRAP_VERSION` MUST therefore be a tag that supports that flag.

The following command builds an image from `./src/Dockerfile`. It pipes the
output to a log file, so you can inspect the output of the build process in
your own time:

```sh
BOOTSTRAP_VERSION=v1.3.0 \
  DOTFILES_VERSION=v1.0.0 \
  make build > build.log 2>&1
```

Alternatively, use `2>&1` to merge stderr into stdout and then pipe to `tee`
which will stream to the log file _and_ pass it through to the terminal at the
same time. But if you do this, preserve `make`'s exit code (else `tee` will
mask it with its own).

```sh
set -o pipefail
BOOTSTRAP_VERSION=v1.3.0 \
  DOTFILES_VERSION=v1.0.0 \
  make build 2>&1 | tee build.log
```

The image build will take several minutes to complete. The image will be added
to your locally running instance of Docker.

### Verifying

Verify the built image with this command:

```sh
docker images kieranpotts/devcontainer:latest
```

Inspect the `build.log` to confirm that no errors were encountered during the
build process. Another useful command is `docker history <image-name>`, which
will show each layer/instruction from the Dockerfile.

Finally, do a manual test. Create a container from the image and shell into it:

```sh
docker run -it --rm kieranpotts/devcontainer:latest bash
```

Inside the container, run a few checks to confirm the environment is set up
as expected:

```sh
# Check OS.
cat /etc/os-release

# Check installed tools.
git --version
python3 --version

# Check the current user and shell.
whoami
echo $SHELL

# Check environment variables
env
```

Exit the container when done:

```sh
exit
```

### Publishing

Images are hosted on [Docker Hub](https://hub.docker.com/r/kieranpotts/devcontainer).

To publish images to Docker Hub, you must have a Docker Hub account and a
personal access token. Follow the steps below to create a new token:

1. Log in to [hub.docker.com](https://hub.docker.com).
2. Click on your username in the top-right → **Account Settings**.
3. Go to **Personal Access Tokens**.
4. Click **Generate New Token**.
5. Name it (eg. `CI image publishing`).
6. Set permission to **Read & Write**, or **Admin** if using teams.
7. Click **Generate**.
8. Copy the token. It is shown in plain text once only.

> [!IMPORTANT]
> Treat the token like a password. Do not commit it to version control.
> If you do, regenerate it immediately via your Docker Hub account
> settings.

Set the below environment variables. Optionally, add these to your shell
profile (`~/.bashrc`, `~/.zshrc`, etc.) to persist them.

```sh
export DOCKER_USERNAME=kieranpotts
export DOCKER_TOKEN=<your-personal-access-token>
```

Update the CHANGELOG, preparing a new release, and commit it:

```
$ git add CHANGELOG.md
$ git commit -m "release: v[major].[minor].[patch]"
```

Tag the HEAD Git commit with the semantic version:

```
$ git tag -a v[major].[minor].[patch]
```

It is RECOMMENDED to include a short message that summarizes the changes in
the release:

```
$ git tag -a v2.1.0 -m "Upgrade base image to latest LTS"
```

Push the new tags and commits:

```
$ git push --follow-tags
```

With the HEAD commit tagged, you can run `make publish` to publish the image
to Docker Hub:

```sh
make publish
```

The `publish` script will:

- Authenticate to Docker Hub using your token.
- Apply a versioned tag, eg. `kieranpotts/devcontainer:1.0.0`, based on the
  current Git tag.
- Push the image, with both the versioned and `latest` tags, to Docker Hub.
- Log out of Docker Hub.

The image will then be available to pull globally. You can choose to sync your
local image with the latest one available from Docker Hub, or pin your image
to a specific release:

```sh
docker pull kieranpotts/devcontainer:latest
docker pull kieranpotts/devcontainer:1.0.0
```

### Usage

This image is intended to be used as a base image for a devcontainer. To use it,
add the following Dockerfile to your repository:

**.devcontainer/Dockerfile**
```Dockerfile
FROM kieranpotts/devcontainer:latest

ENV DEBIAN_FRONTEND=noninteractive

USER code
WORKDIR /workspace
```

Alternatively you can pin your devcontainer to a specific release of the image:

```
FROM kieranpotts/devcontainer:1.3.0
```

Add the following devcontainer configuration. The container's user is set to
`code` and the workspace is mounted at `/workspace`:

**.devcontainer/devcontainer.json**
```json
{
  "remoteUser": "code",
  "workspaceFolder": "/workspace",
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached"
}
```

-----

Copyright © 2025-present Kieran Potts, [MIT license](./LICENSE.txt)
