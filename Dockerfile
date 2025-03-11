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

WORKDIR /workspace

ARG USERNAME=cppuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# non-root user
# RUN useradd -m -s bin/bash cppuser && mkdir /workspace && chown -R cppuser:cppuser /workspace

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER $USERNAME

RUN mkdir -p /home/$USERNAME/bin
ENV PATH="/home/$USERNAME/bin:${PATH}"

# default command (shell)
CMD ["bin/bash"]