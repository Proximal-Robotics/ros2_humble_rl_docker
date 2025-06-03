SHELL := /bin/bash

base:
	docker build --network=host -t ghcr.io/proximal-robotics/ros2_humble_rl_docker/ros2_humble_rl_docker:base -f DockerfileBase .

push-base: base
	docker push ghcr.io/proximal-robotics/ros2_humble_rl_docker/ros2_humble_rl_docker:base