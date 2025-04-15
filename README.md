
# Linuxar Optimization Tool


<p align="center">
  <img src="https://github.com/user-attachments/assets/2dd38653-cee8-4bcf-b20a-603ef6260604" alt="image">
</p>

*A tool to optimize your Linux system by cleaning junk files and applying performance tweaks.*



## Overview

**Linuxar** is a bash script designed to help you optimize your Linux system through cleanup of junk files, system cache clearing, and performance improvements. With a straightforward menu interface, you can choose between optimizing your system or restoring previous settings if needed. This tool is ideal for system administrators and enthusiasts looking to give their Linux machine a performance boost with minimal hassle.



## Features

- **System Cleanup:**  
  - Clears package manager caches (supports APT, DNF, and Pacman).
  - Removes temporary files from `/tmp` and `/var/tmp`.
  - Cleans user caches and truncates older log files.
  - Drops system caches for memory cleanup.

- **Performance Tweaks:**  
  - Adjusts kernel parameters via `/etc/sysctl.conf` (e.g., `vm.swappiness`, `vfs_cache_pressure`, etc.).
  - Changes filesystem mount options to improve performance (adding `noatime,discard` for ext4).
  - Configures zRAM for enhanced memory management.
  - Applies CPU governor tweaks by setting the CPU frequency scaling governor to "performance".
  - Optimizes disk I/O settings (e.g., enabling TRIM for SSDs or setting the HDD scheduler to "deadline").
  - Reduces GRUB timeout to speed up booting.
  - Installs additional performance tools such as **preload** and **haveged** to further enhance system responsiveness.

- **Restore Functionality:**  
  A built-in restore option lets you revert back to the original system settings if the tweaks are not to your liking, ensuring you can experiment safely.

- **Logging & Backups:**  
  Every operation is logged and important configuration files (like `sysctl.conf` and `fstab`) are backed up before changes are applied. This makes it easy to audit adjustments or perform a full restoration.

- **User-Friendly Menu:**  
  Comes with an eye-catching, color-coded text menu that provides clear options:
  - **Optimize System** – Clean junk and apply performance tweaks.
  - **Restore Previous Settings** – Revert your system to its previous configuration.
  - **Exit** – Quit the tool.



## Installation

1. **Clone the Repository**

    ```bash
    git clone https://github.com/White9shadow/linuxar.git
    cd linuxar
    ```

2. **Set Script Permissions**

    Ensure that the script is executable:

    ```bash
    chmod +x linuxar.sh
    ```

3. **Run as Root**

    Since Linuxar needs root privileges to modify system files and settings, run it with sudo:

    ```bash
    sudo ./linuxar.sh
    ```


## 🛠️ HOW TO INSTALL `.deb` FILE IN LINUX

Assume your file is:  
`linuxar_1.0-1.deb`

### ✅ Option 1: Using `dpkg` (manual method)

```bash
sudo dpkg -i linuxar_1.0-1.deb
```

Then fix any missing dependencies (if needed):

```bash
sudo apt -f install
```

---

### ✅ Option 2: Using `apt` (recommended)

```bash
sudo apt install ./linuxar_1.0-1.deb
```

> ✅ This automatically handles dependencies and is cleaner than `dpkg`.

---

### 📂 If the file is in Downloads:

```bash
cd ~/Downloads
sudo apt install ./linuxar_1.0-1.deb
```

---

### 🔍 To Check Installation:

```bash
dpkg -l | grep linuxar
```
[Note] renmae linuxar_1.0-1.deb with linuxar_xxx.deb
---

### ❌ To Uninstall the Package:

```bash
sudo apt remove linuxar
```

---

Let me know if you want a **shell script installer** or a GUI-based method too.

## Usage

Once executed, Linuxar presents a user-friendly menu with the following options:

- **Optimize System:**  
  When selected, the script will:
  - Clean out junk and temporary files.
  - Apply various performance tweaks to kernel and disk settings.
  - Adjust system services and enable/disable additional tools.
  - Log all operations in a dedicated log file located in your backup directory (`~/linuxar_bckup`).

- **Restore Previous Settings:**  
  If any modifications do not suit your needs or cause issues, you can revert the changes using the restoration feature. This function uses the backups created before applying tweaks.

- **Exit:**  
  Simply terminates the script.



## License

**Linuxar Optimization Tool** is released under the **MIT License**. See the [LICENSE](LICENSE) file for details.



## Contributing

Contributions are welcome! Please fork the repository and submit your pull requests if you have any improvements or additional features you'd like to add. Don't hesitate to open an issue if you encounter any bugs or have feature requests.



## Authors

- **White9shadow** – [GitHub Profile](https://github.com/White9shadow)



## Disclaimer

*This script is provided "as is," without warranty of any kind. Use at your own risk. Ensure you have backups and understand the changes being made to your system.*
