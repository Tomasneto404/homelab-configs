# NVIDIA GPU Driver Installer for Ubuntu Server (Docker-Ready)

**Developed by:** Tomás Neto  

## Description

![Ubuntu](https://img.shields.io/badge/OS-Ubuntu%2022.04-blue)
![Docker](https://img.shields.io/badge/Docker-Ready-green)
![License](https://img.shields.io/badge/License-MIT-blue)

Automated script to install the **recommended NVIDIA drivers** on Ubuntu Server, fully prepared for **GPU transcoding (NVENC/NVDEC)** and **Docker containers**.

Supports multiple GPUs, from older Pascal (GTX 1050) to modern Ampere (RTX 3060 Ti).

---

## Features

- Installs the **recommended NVIDIA driver** for your GPU.
- Enables **NVENC/NVDEC** for hardware-accelerated video transcoding.
- Blacklists Nouveau driver to avoid conflicts.
- Installs **Docker** if missing.
- Installs **NVIDIA Container Toolkit (nvidia-docker2)** for GPU access in containers.
- Safe for **headless servers**.
- Post-installation verification commands included.

---

## Requirements

- Ubuntu Server 20.04 or later (tested on 22.04)
- Internet connection
- Sudo privileges

---

## Quick Start (Non-interactive)
1. Copy the code
2. Add execution permissions
```bash
chmod +x install-nvidia-docker.sh
```
3. Run the script
```bash
./install-nvidia-docker.sh
```

---

## Usage Instructions

- Run the script:
```bash
./install-nvidia-docker.sh
```

- Reboot the system when prompted.

- Verify GPU driver:
```bash
nvidia-smi
```

- Check NVENC/NVDEC support with FFmpeg:
```bash
ffmpeg -encoders | grep nvenc
ffmpeg -decoders | grep nvdec
```

- Check GPU access inside Docker:
```bash
docker run --rm --gpus all nvidia/cuda:12.2.1-base-ubuntu22.04 nvidia-smi
```

## Notes

- This script **does not install CUDA** unless required inside a container.
- Multiple GPUs are supported, but **load balancing must be handled by your application** (Docker containers or FFmpeg process assignment).
- Recommended for **Plex, Jellyfin, Emby**, or custom FFmpeg workflows.

---

## Supported GPUs

| GPU Architecture | Example GPUs        | Notes                          |
|-----------------|------------------|--------------------------------|
| Pascal          | GTX 1050, GTX 1060 | NVENC available               |
| Turing          | RTX 2060, RTX 2070 | NVENC + NVDEC, more sessions  |
| Ampere          | RTX 3060 Ti, 3080 | NVENC + NVDEC, max throughput |

