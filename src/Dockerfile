FROM debian:bookworm-slim

LABEL maintainer="Kieran Potts <hello@kieranpotts.com>"

ENV DEBIAN_FRONTEND="noninteractive"

# Install git, clone the bootstrap repository (shallow clone) at a specific
# release, and run the bootstrap script.
RUN apt-get update -q \
    && apt-get install -y --no-install-recommends ca-certificates git \
    && git clone --depth=1 --branch v1.0.0 https://github.com/kieranpotts/bootstrap.git /tmp/bootstrap \
    && cd /tmp/bootstrap \
    && bash ./run/bootstrap.sh \
    && rm -rf /tmp/bootstrap

# Clean up `apt` cache to save space.
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /data
VOLUME ["/data"]

# Keep the container running indefinitely without consuming resources.
CMD ["tail", "-f", "/dev/null"]
