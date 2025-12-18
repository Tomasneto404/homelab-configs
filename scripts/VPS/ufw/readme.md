# Pangolin + Homelab Secure VPS UFW Configuration

**Developed by:** Tomás Neto  

## Description

This Bash script configures **UFW (Uncomplicated Firewall)** on a VPS for a secure setup with a **homelab** and a public service called Pangolin. It applies strict firewall rules by allowing access only from the homelab IP for sensitive services like SSH and WireGuard, while keeping public ports for web traffic open.  

---

## Features Summary

| Step | Action | Effect |
|------|--------|--------|
| 1 | Reset UFW | Resets all existing UFW rules to default |
| 2 | Default Policies | Denies all incoming connections, allows all outgoing |
| 3 | SSH Security | Allows SSH only from `HOMELAB_ADDRESS` and limits login attempts |
| 4 | Public Ports | Opens mandatory public ports: 80 (HTTP) and 443 (HTTPS) |
| 5 | WireGuard | Limits WireGuard ports (51820/21820 UDP) to `HOMELAB_ADDRESS` |
| 6 | Logging | Activates medium-level UFW logging |
| 7 | Enable UFW | Enables UFW on system startup and applies all rules |

---

## How It Works

1. **Set Homelab IP**  
   - Replace the placeholder `X.X.X.X` in `HOMELAB_ADDRESS` with your homelab's public IP.  
   - The script validates that the variable is set correctly before proceeding.

2. **Reset Firewall (Optional)**  
   - Resets any existing UFW rules to ensure a clean configuration.

3. **Set Default Policies**  
   - `deny incoming` – blocks all incoming connections by default  
   - `allow outgoing` – permits all outbound traffic  

4. **Secure SSH Access**  
   - Only allows SSH from your homelab IP  
   - Limits SSH login attempts with `ufw limit 22/tcp`  

5. **Open Public Web Ports**  
   - Opens port 80 (HTTP) and 443 (HTTPS) for public access  

6. **Restrict WireGuard**  
   - Allows WireGuard traffic (UDP ports 51820 and 21820) only from your homelab IP  

7. **Enable Logging**  
   - Activates medium-level UFW logging to monitor firewall events  

8. **Enable UFW**  
   - Forces UFW to enable on startup and applies all configured rules  

---

## How to Use

1. Open the script file in a text editor:

```bash
nano ufw_homelab.sh
```

2. Set your homelab IP:


```bash
HOMELAB_ADDRESS="your.homelab.ip.here"
```

3. Make the script executable:


```bash
chmod +x ufw_homelab.sh
```

4. Run the script with sudo:


```bash
sudo ./ufw_homelab.sh
```

5. The script will display each step and confirm success. At the end, it shows the current UFW status:

```bash
sudo ufw status verbose
```

### Notes

* **Mandatory**: Replace the placeholder X.X.X.X with your real homelab IP before running the script.

* **SSH Access**: Only your homelab IP will be able to connect via SSH after this configuration. Make sure your homelab IP is correct.

* **WireGuard Ports**: Only accessible from your homelab IP for additional security.

* **Logging**: UFW logging is set to medium, useful for monitoring unauthorized access attempts.

* The script is intended for Ubuntu/Debian-based systems with UFW installed.

---

### Example Output

```shell
Applying UFW rules for:
 - Homelab IP: 192.168.1.100

[1/7] Reseting UFW...
[2/7] Defining Default Policies...
[3/7] Allowing SSH only from Homelab...
[4/7] Opening mandatory public ports...
[5/7] Limiting WireGuard to homelab...
[6/7] Activating logs (medium)
[7/7] Enabling UFW on start up ...

============================================
   UFW configured successfully!
============================================
Status: active
To                         Action      From
--                         ------      ----
22/tcp                     LIMIT       192.168.1.100
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
51820/udp                  ALLOW       192.168.1.100
21820/udp                  ALLOW       192.168.1.100
```