# Devcontainer Docker image

**Build script for a Docker image for use in devcontainers.**

The built Docker image is based on Debian slim and it installs the CLI profile
toolset from my [bootstrap scripts](https://github.com/kieranpotts/bootstrap):

```sh
./run/install --profile=cli
```

The image is used as a base for my devcontainer, which is configured in the
[workspace repository](https://github.com/kieranpotts/workspace).

## 💻 Usage

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

```Dockerfile
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

## 📓 Developer documentation

See the [contributing guidelines](./CONTRIBUTING.md).

-----

Copyright © 2025-present Kieran Potts, [MIT license](./LICENSE.txt)
