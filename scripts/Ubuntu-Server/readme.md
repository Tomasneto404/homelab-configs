# Ubuntu Server Post-Installation Script

**Developed by:** Tomás Neto  

## Description

This Bash script automates post-installation tasks on **Ubuntu Server**. It updates the system, installs drivers and essential software, configures firewall and security tools, and optionally sets up Docker in rootless mode. The script is **interactive**, prompting the user for confirmation before performing each major action.  

---

## Features Summary

| Step | Action | User Prompt | Effect |
|------|--------|------------|--------|
| 1 | System Update & Upgrade | Automatic (no prompt) | Updates system packages to latest versions |
| 2 | Hardware Drivers | Automatic (no prompt) | Installs recommended drivers for the hardware |
| 3 | Git Installation | "Install Git?" | Installs Git version control system |
| 4 | Python Installation | "Install Python + pip + venv?" | Installs Python3, pip, and venv packages |
| 5 | UFW Firewall | "Configure UFW firewall?" | Configures firewall to deny incoming, allow outgoing, enables SSH, HTTP, HTTPS |
| 6 | Fail2Ban | "Install and configure Fail2Ban?" | Monitors SSH login attempts, blocks IPs after 5 failures for 1 hour |
| 7 | Docker Rootless | "Install Docker (rootless mode)?" | Installs Docker for current user, configures environment, enables rootless service |
| 8 | Docker Hello World | "Run Docker Hello World?" | Runs a test container to verify Docker installation |

---

## How It Works

1. **Color-coded messages**  
   - `[INFO]` – Blue, general information  
   - `[OK]` – Green, success messages  
   - `[WARN]` – Yellow, warnings  
   - `[ERRO]` – Red, errors  

2. **User Interaction**  
   - Prompts for `Y/n` before executing optional tasks.  
   - Default is **Yes** if Enter is pressed.  

3. **System Update & Drivers**  
   - Updates packages with `apt update && apt upgrade -y`.  
   - Installs hardware drivers with `ubuntu-drivers autoinstall`.  

4. **Software Installation**  
   - Git, Python (with pip and venv), and Docker rootless are optional.  
   - Docker environment is added to `$HOME/bin` and `~/.bashrc`.  

5. **Firewall (UFW)**  
   - Denies all incoming connections by default  
   - Allows all outgoing connections  
   - Allows SSH, HTTP, HTTPS  
   - Enables firewall automatically  

6. **Fail2Ban**  
   - Monitors SSH login attempts in `/var/log/auth.log`  
   - Bans IPs for 1 hour after 5 failed login attempts  

7. **Docker Hello World Test**  
   - Runs `docker run --rm hello-world`  
   - Warns if Docker did not run (requires logout/login in rootless mode)  

---

## How to Use

1. Save the script as `post_install.sh`.  
2. Make it executable:

```bash
chmod +x post_install.sh
```

3. Run the script

```bash
./post_install.sh
```

4. Follow the interactive prompts to install and configure the software you need.