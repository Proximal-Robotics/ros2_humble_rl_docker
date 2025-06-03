#!/bin/bash
set -e
shopt -s nullglob

# -----------------------------
# .bashrc sourcing setup
# -----------------------------
BASHRC_GLOBAL="/docker_entrypoint/.bashrc"

if [ -f "$BASHRC_GLOBAL" ]; then
    cp "$BASHRC_GLOBAL" "/root/.bashrc.ros2" 2>/dev/null || true
fi

# -----------------------------
# Print IPs
# -----------------------------
echo "Container IPs: $(hostname --all-ip-addresses)"

# -----------------------------
# Run passed command or shell
# -----------------------------
if [[ $# -gt 0 ]]; then
    echo "$@" > /tmp/.runscript.sh
    chmod +x /tmp/.runscript.sh
    exec /bin/bash -l -c "/tmp/.runscript.sh"
else
    exec /bin/bash --login -i
fi

