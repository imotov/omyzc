FROM debian:stable-slim

# Avoid tzdata prompts, etc.
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    fdupes \
    exiftool \
    # add whatever you like here...
 && rm -rf /var/lib/apt/lists/*

# Make fd available as `fd` on Debian/Ubuntu
RUN if command -v fdfind >/dev/null 2>&1; then ln -s "$(command -v fdfind)" /usr/local/bin/fd; fi

WORKDIR /work