# ROS 2 Humble RL Docker

This repository contains a Docker-based setup to run IsaacLab in [ROS 2 Humble](https://docs.ros.org/en/humble/) on **Ubuntu 22.04**, with **Python 3.10 support** and full **GPU acceleration via NVIDIA**.

---

## Quick Start

### 1. Build the Docker image or pull from container registry

From the root of the repo:

You can build the container by typing `make` in the root directory of this repo.

---

### 2. Start the container

Use the provided `start_ros2_humble_rl_docker.sh` script to start the container with:
- NVIDIA GPU acceleration
- Host user permissions

```bash
./start_ros2_humble_rl_docker.sh
```

The script will:
- Start a new container (`ros2_humble_rl_docker_$USER`) if not already running.
- Otherwise, attach a new terminal to the running container.

---

## Troubleshooting

- Make sure you have the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) installed.
- If you don’t see GUIs, ensure X11 forwarding works:
  - `xhost +local:root` on the host (temporary; for development only).

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Acknowledgements

- [ROS 2](https://docs.ros.org/en/humble/)
- NVIDIA for GPU container support

