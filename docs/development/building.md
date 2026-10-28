# Building

## Requirements

- Docker
- Make
- Git

## Prerequisites

Make the `run/*` scripts executable:

```sh
chmod +x run/*
```

## Building

The build script prompts for the target versions of bootstrap and dotfiles. The
bootstrap version MUST match a tag in the `kieranpotts/bootstrap` repository,
and the dotfiles version MUST match a tag in the `kieranpotts/dotfiles`
repository. The prompts are written to, and read from, the terminal directly,
so they still appear when the build output is redirected to a log file.

To build unattended, set the `BOOTSTRAP_VERSION` and `DOTFILES_VERSION`
environment variables instead. The script only prompts for a version that isn't
set in the environment:

```sh
BOOTSTRAP_VERSION=v1.7.1 \
  DOTFILES_VERSION=v1.2.0 \
  make build > build.log 2>&1
```

The following command builds an image from `./src/Dockerfile`. It pipes the
output to a log file, so you can inspect the output of the build process in
your own time:

```sh
make build > build.log 2>&1
```

Alternatively, use `2>&1` to merge stderr into stdout and then pipe to `tee`
which will stream to the log file _and_ pass it through to the terminal at the
same time. But if you do this, preserve `make`'s exit code (else `tee` will
mask it with its own).

```sh
set -o pipefail
make build 2>&1 | tee build.log
```

The image build will take several minutes to complete. The image will be added
to your locally running instance of Docker.

## Verifying

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
