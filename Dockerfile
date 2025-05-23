# debian slim to reduce image size
FROM debian:12-slim

# build arguments and environment variables
ARG USERNAME=cppuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV WORK_DIR="/workspace"
ENV CURR_USR=$USERNAME

# from this line onward, all commands will be executed in the following directory
WORKDIR $WORK_DIR

# copy needed files into the container
COPY ./CMakeLists.txt ./CMakeLists.txt
COPY ./.vscode ./.vscode

# essential tools for cpp development
RUN apt-get update && apt-get install -y \
    sudo \
    build-essential \
    cmake \
    gdb \
    git \
    curl \
    libboost-all-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# create a non-root user with sudo privileges
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -ms /bin/bash $USERNAME && \
    echo "$USERNAME ALL=\(root\) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    chown -R $USERNAME:$USERNAME $WORK_DIR

# set the user to run the container
USER $USERNAME

# create and add the user's bin directory to the PATH env variable
RUN mkdir -p /home/$USERNAME/bin
ENV PATH="/home/$USERNAME/bin:${PATH}"

# default command (shell)
CMD ["/bin/bash"]