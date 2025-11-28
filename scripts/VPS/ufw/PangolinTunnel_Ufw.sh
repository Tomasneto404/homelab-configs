#!/bin/bash

#############################################################################
# Pangolin + Homelab Secure VPS UFW Configuration (Developed by Tomás Neto) #
#############################################################################

# === Variables ==============================
HOMELAB_ADDRESS="X.X.X.X"   # <-- Put Here Homelab Address

# === Basic Validation =======================
if [[ -z "$HOMELAB_ADDRESS" || "$HOMELAB_ADDRESS" == "X.X.X.X" ]]; then
    echo "[ERROR] HOMELAB_ADDRESS is empty or still set to placeholder X.X.X.X!"
    exit 1
fi

echo "Applying UFW rules for:"
echo " - Homelab IP: $HOMELAB_ADDRESS"
echo

# === Reset (Opcional) =======================
echo "[1/7] Reseting UFW..."
sudo ufw --force reset

# === Policies ===============================
echo "[2/7] Definig Default Politics..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

# === Secure SSH =============================
echo "[3/7] Allowing SSH only from Homelab..."
sudo ufw allow from "$HOMELAB_ADDRESS" to any port 22
sudo ufw limit 22/tcp

# === Pangolin Ports =====================
echo "[4/7] Opening mandatory public ports..."
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# === WireGuard ==============================
echo "[5/7] Limiting Wireguard to homelab..."
sudo ufw allow from "$HOMELAB_ADDRESS" to any port 51820 proto udp
sudo ufw allow from "$HOMELAB_ADDRESS" to any port 21820 proto udp

# === Logging ================================
echo "[6/7] Activating logs (medium)"
sudo ufw logging medium

# === Enable =================================
echo "[7/7] Enabling UFW on start up ..."
sudo ufw --force enable

echo
echo "============================================"
echo "   UFW configured successfully!"
echo "============================================"
sudo ufw status verbose
