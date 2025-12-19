#!/bin/bash

##########################################
# Ubuntu Server Post Installation Script #
# Copyright (c) 2025 Tomás Neto          #
# Licensed under the MIT License         #
##########################################


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


########################################################
# Start Script
########################################################

if ask_yes_no "Continue Post Installation Script?"; then
    msg_ok "Continuing..."

    ####################################################
    # Update System
    ####################################################
    msg_info "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    msg_ok "System updated."

    ####################################################
    # Drivers
    ####################################################
    msg_info "Installing hardware drivers..."
    sudo apt install -y ubuntu-drivers-common
    sudo ubuntu-drivers autoinstall
    msg_ok "Drivers installation complete."


    ####################################################
    # Git
    ####################################################
    if ask_yes_no "Install Git?"; then
        msg_info "Installing Git..."
        sudo apt install -y git
        msg_ok "Git installed!"
    fi


    ####################################################
    # Python
    ####################################################
    if ask_yes_no "Install Python + pip + venv?"; then
        msg_info "Installing Python packages..."
        sudo apt install -y python3 python3-pip python3-venv
        msg_ok "Python, pip and venv installed!"
    fi


    ####################################################
    # Firewall UFW
    ####################################################
    if ask_yes_no "Configure UFW firewall?"; then
        msg_info "Configuring UFW..."

        sudo apt install -y ufw

        sudo ufw default deny incoming
        sudo ufw default allow outgoing

        sudo ufw allow ssh
        sudo ufw allow http
        sudo ufw allow https

        echo "y" | sudo ufw enable >/dev/null 2>&1

        msg_ok "UFW configured and enabled!"
    fi


    ####################################################
    # Fail2Ban
    ####################################################
    if ask_yes_no "Install and configure Fail2Ban?"; then
        msg_info "Installing Fail2Ban..."
        sudo apt install -y fail2ban

        sudo tee /etc/fail2ban/jail.local >/dev/null <<EOF
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 1h
EOF

        sudo systemctl restart fail2ban
        sudo systemctl enable fail2ban

        msg_ok "Fail2Ban installed and configured!"
    fi


    ####################################################
    # Docker Rootless
    ####################################################
    if ask_yes_no "Install Docker (rootless mode)?"; then
        msg_info "Installing Docker rootless dependencies..."

        sudo apt install -y uidmap dbus-user-session fuse-overlayfs slirp4netns

        msg_info "Installing Docker (rootless)..."

        curl -fsSL https://get.docker.com/rootless | sh

        export PATH=/home/$USER/bin:$PATH
        echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

        msg_ok "Docker rootless installed!"

        msg_info "Enabling Docker service (rootless)..."
        systemctl --user enable docker
        systemctl --user start docker

        msg_ok "Docker rootless service running!"
    fi


    ####################################################
    # Docker Hello World
    ####################################################
    if ask_yes_no "Run Docker Hello World?"; then
        msg_info "Running Docker hello-world container..."

        if docker run --rm hello-world; then
            msg_ok "Docker Hello-World executed successfully!"
        else
            msg_warn "Docker did not run. (Rootless mode requires logout/login)"
        fi
    fi


    ####################################################
    # Finish
    ####################################################
    msg_ok "Installation Finished!"
    msg_info "Please logout and login again to make changes"

else
    msg_warn "Installation aborted by user."
fi
