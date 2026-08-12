# Publishing

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
$ git commit -m "version: [major].[minor].[patch]"
```

Tag the HEAD Git commit with the semantic version:

```
$ git tag -a v[major].[minor].[patch]
```

Alternatively, use the `make version` or `./run/version` script.

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
