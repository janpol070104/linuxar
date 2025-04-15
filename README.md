
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

- **deb**
  `linuxar`
  
  

## 🧪 Example Output of `linuxar` Optimization Tool (Sanitized)


<summary>Click to expand full terminal log</summary>

```bash
┌──(roro㉿revws)-[~]
└─$ sudo linuxar
----------------------------------------------------
            LINUXAR OPTIMIZATION TOOL            
            by White9shadow @ GitHub            
            Version : 1.0.1            
----------------------------------------------------

Description: This tool helps you clean junk files,
optimize system settings, and improve performance
on your Linux machine. The system can be easily
optimized using built-in commands and tweaks.
----------------------------------------------------

License: MIT License

1. Optimize System (Clean junk, apply tweaks)
2. Restore Previous Settings
3. Exit
Choose an option (1-3): 1
Cleaning junk files...
Cleared system cache
Cleaned /tmp and /var/tmp
Cleaned old user cache files
Truncated old logs
Applying performance tweaks...
Backed up /etc/sysctl.conf
Optimized kernel parameters
Disabled unnecessary services
Backed up /etc/fstab
Added noatime,discard to ext4 mounts
Enabled zram swap
Applying v2
CPU governor set to performance.
vm.swappiness = 10
Swappiness set to 10.
I/O scheduler set to deadline for HDD.
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
0 upgraded, 0 newly installed, 0 to remove and 2753 not upgraded.
Vacuuming done, freed 0B of archived journals from /var/log/journal/******.
Vacuuming done, freed 0B of archived journals from /run/log/journal.
Vacuuming done, freed 0B of archived journals from /var/log/journal.
Clean up completed.
Generating grub configuration file ...
Found theme: /boot/grub/themes/kali/theme.txt
Found background image: /usr/share/images/desktop-base/desktop-grub.png
Found linux image: /boot/vmlinuz-******-amd64
Found initrd image: /boot/initrd.img-******-amd64
Found linux image: /boot/vmlinuz-******-amd64
Found initrd image: /boot/initrd.img-******-amd64
Found linux image: /boot/vmlinuz-******-amd64
Found initrd image: /boot/initrd.img-******-amd64
Found linux image: /boot/vmlinuz-******-amd64
Found initrd image: /boot/initrd.img-******-amd64
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
Adding boot menu entry for UEFI Firmware Settings ...
done
GRUB timeout set to 2 seconds.
Printer service not found. Skipping.
Get:1 http://deb.anydesk.com all InRelease [7,386 B]                                                                                                                   
Hit:2 http://http.kali.org/kali kali-rolling InRelease                                                                                                                 
Hit:3 https://linux.teamviewer.com/deb stable InRelease                                                                                                                
Hit:4 https://brave-browser-apt-release.s3.brave.com stable InRelease                                                                                                  
Hit:5 https://linux.teamviewer.com/deb preview InRelease
Hit:6 https://packages.microsoft.com/repos/code stable InRelease
Err:1 http://deb.anydesk.com all InRelease
  Sub-process /usr/bin/sqv returned an error code (1), error message is: Missing key **********************, which is needed to verify signature.
Fetched 7,386 B in 1s (5,242 B/s)
Reading package lists... Done
W: An error occurred during the signature verification. The repository is not updated and the previous index files will be used. OpenPGP signature verification failed: http://deb.anydesk.com all InRelease: Sub-process /usr/bin/sqv returned an error code (1), error message is: Missing key **********************, which is needed to verify signature.
W: Failed to fetch http://deb.anydesk.com/dists/all/InRelease  Sub-process /usr/bin/sqv returned an error code (1), error message is: Missing key **********************, which is needed to verify signature.
W: Some index files failed to download. They have been ignored, or old ones used instead.
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
preload is already the newest version (0.6.4-5+b2).
The following packages will be upgraded:
  haveged libhavege2
2 upgraded, 0 newly installed, 0 to remove and 2751 not upgraded.
Need to get 63.0 kB of archives.
After this operation, 0 B of additional disk space will be used.
Get:1 http://kali.download/kali kali-rolling/main amd64 libhavege2 amd64 1.9.19-11 [25.5 kB]
Get:2 http://kali.download/kali kali-rolling/main amd64 haveged amd64 1.9.19-11 [37.5 kB]
Fetched 63.0 kB in 2s (36.6 kB/s) 
(Reading database ... ****** files and directories currently installed.)
Preparing to unpack .../libhavege2_1.9.19-11_amd64.deb ...
Unpacking libhavege2:amd64 (1.9.19-11) over (1.9.19-10) ...
Preparing to unpack .../haveged_1.9.19-11_amd64.deb ...
Unpacking haveged (1.9.19-11) over (1.9.19-10) ...
Setting up libhavege2:amd64 (1.9.19-11) ...
Setting up haveged (1.9.19-11) ...
Processing triggers for libc-bin (2.40-2) ...
Processing triggers for man-db (2.13.0-1) ...
Processing triggers for kali-menu (2024.3.1) ...
preload.service is not a native service, redirecting to systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable preload
Preload enabled.
haveged enabled.
```



## License

**Linuxar Optimization Tool** is released under the **MIT License**. See the [LICENSE](LICENSE) file for details.



## Contributing

Contributions are welcome! Please fork the repository and submit your pull requests if you have any improvements or additional features you'd like to add. Don't hesitate to open an issue if you encounter any bugs or have feature requests.



## Authors

- **White9shadow** – [GitHub Profile](https://github.com/White9shadow)



## Disclaimer

*This script is provided "as is," without warranty of any kind. Use at your own risk. Ensure you have backups and understand the changes being made to your system.*
