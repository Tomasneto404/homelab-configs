# Homelab Configurations

**Maintained by:** Tomás Neto  

## Overview

This repository contains a collection of **scripts, configuration files, and documentation** for managing and automating tasks in a **homelab environment**. Its purpose is to help you set up, secure, and maintain servers, VPS, and services efficiently while following best practices for networking, automation, and system administration.  

It is suitable for personal homelabs, home servers, and small public-facing VPS setups.

---

## Repository Structure

| Folder / File | Description |
|---------------|-------------|
| `docker-services/` | Contains Docker-related configurations, templates, and deployment scripts for running services in containers. Includes rootless Docker setups, example service containers, and Docker Compose templates for easy deployment in a homelab environment. |
| `configs/` | Configuration files for services, firewall rules, Docker, networking, and other applications. |
| `scripts/` |Automation and setup scripts (e.g., post-install scripts, media organization, Docker setup).  |
| `README.md` | This overview file. |
| `LICENSE` | Open source license for usage and contributions. |

---

## Examples of Included Content

### Scripts

- **Post-Installation Scripts:** Automates updates, installs software (Git, Python, Docker), configures firewall (UFW), Fail2Ban, and other server essentials.  
- **Media Organizer:** Organizes files into individual folders automatically.  
- **UFW Configuration Scripts:** Secures VPS by restricting SSH and VPN access to homelab IPs and opening only necessary public ports.

### Configurations

- **Firewall configs (UFW)** for secure server access.  
- **Docker configuration templates** for rootless or service-specific containers.  
- **Service configuration examples** for WireGuard, SSH, and other server apps.

### Documentation

- Step-by-step guides for scripts and configurations.  
- Best practices for homelab security, automation, and service deployment.  
- Notes for customization and troubleshooting.

---

## How to Use

1. **Clone the repository:**

```bash
git clone https://github.com/your-username/homelab-configs.git
cd homelab-configs
