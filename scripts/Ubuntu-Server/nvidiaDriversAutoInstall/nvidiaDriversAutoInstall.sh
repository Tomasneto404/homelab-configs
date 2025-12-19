#!/bin/bash

#################################################
# Ubuntu Server NVIDIA GPU Drivers Installation #
# Copyright (c) 2025 Tomás Neto                 #
# Licensed under the MIT License                #
#################################################


########################################################
# Colors
########################################################
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

########################################################
# Functions
########################################################
msg_info()  { echo -e "${BLUE}[INFO]${RESET} $1"; }
msg_ok()    { echo -e "${GREEN}[OK]${RESET} $1"; }
msg_warn()  { echo -e "${YELLOW}[WARN]${RESET} $1"; }
msg_err()   { echo -e "${RED}[ERROR]${RESET} $1"; }

ask_yes_no() {
    read -p "$1 (Y/n) " answer
    
    if [ -z "$answer" ] || [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        return 0
    else
        return 1
    fi
}


if ask_yes_no "Continue Nvidia GPU driver installation?"; then
    msg_ok "Continuing...";
    
    ########################################################
    # Remove conflicting repositories (safe)
    ########################################################
    msg_info "Removing old NVIDIA repositories (if any)..."
    sudo add-apt-repository --remove ppa:graphics-drivers/ppa -y || true
    sudo rm -f /etc/apt/sources.list.d/graphics-drivers-ubuntu-ppa*.list
    sudo rm -f /etc/apt/sources.list.d/graphics-drivers-ubuntu-ppa*.sources
    sudo rm -f /etc/apt/sources.list.d/nvidia-drivers.list
    sudo rm -f /etc/apt/sources.list.d/nvidia-cuda.sources
    msg_ok "Old repositories cleaned."
    
    ########################################################
    # Blacklist nouveau (defensive)
    ########################################################
    msg_info "Blacklisting nouveau driver..."
sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null <<EOF
blacklist nouveau
options nouveau modeset=0
EOF
    sudo update-initramfs -u
    msg_ok "Nouveau driver disabled."
    
    ########################################################
    # Update system (safe)
    ########################################################
    msg_info "Updating package lists..."
    sudo add-apt-repository restricted -y
    sudo apt update
    msg_ok "Repositories updated."
    
    ########################################################
    # Detect recommended NVIDIA driver
    ########################################################
    msg_info "Detecting recommended NVIDIA driver..."
    DRIVER=$(ubuntu-drivers devices | awk '/recommended/ {print $3}')
    
    if [ -z "$DRIVER" ]; then
        msg_err "No recommended NVIDIA driver found."
        exit 1
    fi
    
    VERSION=$(echo "$DRIVER" | grep -o '[0-9]\+')
    msg_ok "Recommended driver detected: $DRIVER"
    
    ########################################################
    # Install NVIDIA driver + NVENC/NVDEC
    ########################################################
    msg_info "Installing NVIDIA driver and NVENC/NVDEC libraries..."
    sudo apt install -y \
    "$DRIVER" \
    "nvidia-utils-$VERSION" \
    "libnvidia-encode-$VERSION"
    msg_ok "NVIDIA driver installation completed."
    
    ########################################################
    # Install Docker + NVIDIA Container Toolkit
    ########################################################
    msg_info "Installing Docker and NVIDIA Container Toolkit..."
    
    # Install Docker if not present
    if ! command -v docker &> /dev/null; then
        msg_info "Installing Docker..."
        sudo apt install -y docker.io
        sudo systemctl enable docker --now
        msg_ok "Docker installed."
    fi
    
    # Install NVIDIA Container Toolkit
    if ! dpkg -s nvidia-docker2 &> /dev/null; then
        distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
        curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
        curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
        sudo apt update
        sudo apt install -y nvidia-docker2
        sudo systemctl restart docker
        msg_ok "NVIDIA Container Toolkit installed."
    fi
    
    ########################################################
    # Final instructions
    ########################################################
    msg_warn "System must be rebooted to activate NVIDIA drivers and Docker integration."
    
    msg_info "After reboot, validate GPU availability inside Docker:"
    echo "  docker run --rm --gpus all nvidia/cuda:12.2.1-base-ubuntu22.04 nvidia-smi"
    
    if ask_yes_no "Reboot now?"; then
        sudo reboot
    fi
fi

