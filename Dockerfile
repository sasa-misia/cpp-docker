# Debian slim to reduce image size
FROM debian:12-slim

# essential tools for cpp development
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    gdb \
    git \
    curl \
    libboost-all-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# non-root user
RUN useradd -m cppuser && mkdir /workspace && chown cppuser:cppuser /workspace
WORKDIR /workspace
USER cppuser

# default command (shell)
CMD ["/bin/bash"]