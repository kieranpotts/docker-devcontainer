FROM debian:bookworm-slim

LABEL maintainer="Kieran Potts <work@kieranpotts.com>"

ENV DEBIAN_FRONTEND="noninteractive"

# Install prerequisites for cloning and running the setup scripts.
RUN apt-get update -q \
    && apt-get install -y --no-install-recommends ca-certificates git

# Install dotfiles first. This creates ~/local.bashrc (among other files),
# which the bootstrap scripts will detect and write tool init code into
# (NVM, Jabba, phpenv, etc.), rather than writing directly to ~/.bashrc.
# The clone must be kept at /root/.dotfiles because ~/.bashrc and other
# shell startup files are symlinked into it. (This is not pinned to a
# specific version.)
RUN git clone --depth=1 --branch dev https://github.com/kieranpotts/dotfiles.git /root/.dotfiles \
    && cd /root/.dotfiles \
    && bash ./install.sh

# Clone the bootstrap repository (shallow clone) at a specific release
# and run the bootstrap script.
RUN git clone --depth=1 --branch v1.0.0 https://github.com/kieranpotts/bootstrap.git /tmp/bootstrap \
    && cd /tmp/bootstrap \
    && bash ./run/bootstrap.sh \
    && rm -rf /tmp/bootstrap

# Clean up `apt` cache to save space.
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /data
VOLUME ["/data"]

# Keep the container running indefinitely without consuming resources.
CMD ["tail", "-f", "/dev/null"]
