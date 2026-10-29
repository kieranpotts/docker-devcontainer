FROM debian:bookworm-slim

LABEL maintainer="Kieran Potts <code@kieranpotts.com>"

# Version of the bootstrap repository to clone and run. Bump this to pull in
# changes from https://github.com/kieranpotts/bootstrap. This will be overwritten
# via the `--build-arg` option passed via the `./run/build` script.
ARG BOOTSTRAP_VERSION=v0.0.0

# Version of the dotfiles repository to clone and install. Bump this to pull in
# changes from https://github.com/kieranpotts/dotfiles. This will be overwritten
# via the `--build-arg` option passed via the `./run/build` script.
ARG DOTFILES_VERSION=v0.0.0

ENV DEBIAN_FRONTEND="noninteractive"

# Update repository lists.
RUN apt-get update -q

# Install prerequisites for cloning and running the setup scripts.
RUN apt-get install -y --no-install-recommends ca-certificates git sudo

# Also add SSH client, so that we can pull and push to remote Git repositories
# over SSH from inside the container. An SSH client is not available by default
# in the minimal Debian base image.
RUN apt-get install -y openssh-client

# Create non-root "code" user.
RUN groupadd --gid 1000 code && \
    useradd --uid 1000 --gid 1000 -m -s /bin/bash code

# Allow the code user to run sudo without a password during build and runtime.
RUN echo 'code ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/code && \
    chmod 0440 /etc/sudoers.d/code

# Install dotfiles for the "code" user. This creates ~/local.bashrc
# (among other files), which the bootstrap scripts will detect and write
# initialize code into for various tools (NVM, Jabba, phpenv, etc.), rather
# than writing directly to ~/.bashrc.
RUN git clone --depth=1 --branch "${DOTFILES_VERSION}" https://github.com/kieranpotts/dotfiles.git /home/code/.dotfiles \
    && chown -R code:code /home/code/.dotfiles

# Switch to the "code" user and run the dotfiles install script.
USER code
RUN cd /home/code/.dotfiles && bash ./install.sh

# Clone the bootstrap repository (shallow clone) at a specific release and run
# the install script as the "code" user.
#
# `--profile=cli` installs only the bootstrap's "core" step set: the minimal
# tooling a coding agent needs in a headless container.
#
# `BOOTSTRAP_VERSION` MUST therefore be a tag that provides both `run/install`
# and `--profile=cli`. Older tags do not, and the build will fail on an
# unknown argument.
RUN git clone --depth=1 --branch "${BOOTSTRAP_VERSION}" https://github.com/kieranpotts/bootstrap.git /tmp/bootstrap \
    && cd /tmp/bootstrap \
    && ./run/install --profile=cli \
    && rm -rf /tmp/bootstrap

# Switch back to root so we can clean up the apt cache.
USER root

# Clean up `apt` cache to save space.
RUN rm -rf /var/lib/apt/lists/*

# Restore the non-root default user.
USER code

# Add user-level bin directories to PATH for every process in the container, not
# only interactive shells. pipx tools and Poetry are installed into ~/.local/bin,
# mise links the tools that a project pins into its shims directory, and NVM
# points ~/.nvm/current at the default Node.js version. ~/.bashrc sets these
# up, but only interactive Bash shells read ~/.bashrc. Commands run any other
# way - via `docker exec`, editor tasks, Git hooks, or coding agents - would
# otherwise not find those tools. mise's shims come first, so a Node.js version
# pinned in a project's `mise.toml` takes precedence over NVM's default.
ENV PATH="/home/code/.local/share/mise/shims:/home/code/.local/bin:/home/code/.nvm/current/bin:${PATH}"

WORKDIR /data
VOLUME ["/data"]

# Keep the container running indefinitely without consuming resources.
CMD ["tail", "-f", "/dev/null"]
