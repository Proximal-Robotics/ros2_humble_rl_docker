#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Docker options
DOCKER_USER_ARGS="--privileged"
DOCKER_GPU_ARGS="--env DISPLAY=${DISPLAY} \
--env QT_X11_NO_MITSHM=1 \
--env TERM=xterm-256color \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:rw"

# Add GPU access (NVIDIA)
DOCKER_COMMAND=docker
DOCKER_VERSION="$(docker version --format '{{.Client.Version}}' 2>/dev/null)"
verlte() { [ "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]; }

if verlte 19.03 "$DOCKER_VERSION"; then
    DOCKER_GPU_ARGS="--gpus all $DOCKER_GPU_ARGS"
    DOCKER_GPU_ARGS="$DOCKER_GPU_ARGS \
        --env NVIDIA_VISIBLE_DEVICES=all \
        --env NVIDIA_DRIVER_CAPABILITIES=all"
fi

xhost +local:

IMAGE_NAME=ghcr.io/Proximal-Robotics/ros2_humble_rl_docker/ros2_humble_rl_docker:base
CONTAINER_NAME=${IMAGE_NAME}_root

ADDITIONAL_FLAGS="--rm --interactive --tty"
ADDITIONAL_FLAGS+=" --device /dev/dri:/dev/dri"
ADDITIONAL_FLAGS+=" --volume=/run/udev:/run/udev"
ADDITIONAL_FLAGS+=" --ulimit rtprio=99:99 --ulimit memlock=102400:102400"

# Run container as root
if ! docker container ps | grep -q "$CONTAINER_NAME"; then
    echo "Starting new container with name: $CONTAINER_NAME"
    $DOCKER_COMMAND run \
        --userns=host \
        $DOCKER_USER_ARGS \
        $DOCKER_GPU_ARGS \
        -v "$HOME:/root/host_home" \
        -v "/dev:/dev" \
        -v "/etc/udev:/etc/udev" \
        $ADDITIONAL_FLAGS \
        --name "$CONTAINER_NAME" \
        --cap-add=SYS_PTRACE \
        --cap-add=SYS_NICE \
        --net host \
        --device /dev/bus/usb \
        --device /dev/snd \
        --group-add audio \
        --volume /usr/share/vulkan:/usr/share/vulkan:ro \
        --device /dev/pts \
        "$IMAGE_NAME"
else
    echo "Starting shell in running container"
    docker exec -it \
        "$CONTAINER_NAME" \
        bash -l -i -c "stty cols $(tput cols); stty rows $(tput lines); exec bash"
fi

