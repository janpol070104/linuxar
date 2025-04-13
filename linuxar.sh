#!/bin/bash

# Author: White9shadow @ GitHub
# Description: Linuxar Optimization Tool - Optimize Linux system by cleaning junk and applying performance tweaks.
# License: MIT License
# Includes a restore option to revert changes
# Run as root (sudo ./linuxar.sh)

    # Define color codes
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    PURPLE='\033[0;35m'
    CYAN='\033[0;36m'
    RESET='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root (sudo)."
    exit 1
fi

# Define backup directory
BACKUP_DIR="$HOME/linuxar_bckup"
mkdir -p "$BACKUP_DIR"

# Log file for tracking changes
LOG_FILE="$BACKUP_DIR/optimize_log.txt"
echo "Optimization Log - $(date)" > "$LOG_FILE"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to backup a file
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR/$(basename "$file").$(date +%F_%T)"
        echo "Backed up $file" | tee -a "$LOG_FILE"
    fi
}

# Function to display menu
show_menu() {

    echo -e "${PURPLE}----------------------------------------------------${RESET}"
    echo -e "${PURPLE}            LINUXAR OPTIMIZATION TOOL            ${RESET}"
    echo -e "${PURPLE}            by White9shadow @ GitHub            ${RESET}"
    echo -e "${PURPLE}            Version : BETA 1            ${RESET}"
    echo -e "${PURPLE}----------------------------------------------------${RESET}"
    echo
    echo -e "${CYAN}Description: This tool helps you clean junk files,${RESET}"
    echo -e "${CYAN}optimize system settings, and improve performance${RESET}"
    echo -e "${CYAN}on your Linux machine. The system can be easily${RESET}"
    echo -e "${CYAN}optimized using built-in commands and tweaks.${RESET}"
    echo -e "${CYAN}----------------------------------------------------${RESET}"
    echo
    echo -e "${PURPLE}License: MIT License${RESET}"
    echo
    echo
    echo -e "${GREEN}1. Optimize System (Clean junk, apply tweaks)${RESET}"
    echo -e "${YELLOW}2. Restore Previous Settings${RESET}"
    echo -e "${RED}3. Exit${RESET}"

    read -p "Choose an option (1-3): " choice
}

# Function to clean junk files
clean_junk() {
    echo "Cleaning junk files..." | tee -a "$LOG_FILE"
    
    # Update package lists
    if command_exists apt; then
        apt update -y >> "$LOG_FILE" 2>&1
        apt autoremove -y >> "$LOG_FILE" 2>&1
        apt autoclean -y >> "$LOG_FILE" 2>&1
    elif command_exists dnf; then
        dnf autoremove -y >> "$LOG_FILE" 2>&1
        dnf clean all -y >> "$LOG_FILE" 2>&1
    elif command_exists pacman; then
        pacman -Sc --noconfirm >> "$LOG_FILE" 2>&1
        pacman -Rns $(pacman -Qtdq) --noconfirm >> "$LOG_FILE" 2>&1
    fi

    # Clear system cache
    sync
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
    echo "Cleared system cache" | tee -a "$LOG_FILE"

    # Clean temporary files
    rm -rf /tmp/* /var/tmp/* 2>/dev/null
    echo "Cleaned /tmp and /var/tmp" | tee -a "$LOG_FILE"

    # Clean user cache (non-root)
    find "$HOME/.cache/" -type f -atime +30 -delete 2>/dev/null
    echo "Cleaned old user cache files" | tee -a "$LOG_FILE"

    # Clean old logs
    find /var/log -type f -name "*.log" -exec truncate -s 0 {} \; 2>/dev/null
    echo "Truncated old logs" | tee -a "$LOG_FILE"
}

# Function to apply performance tweaks
apply_tweaks() {
    echo "Applying performance tweaks..." | tee -a "$LOG_FILE"

    # Backup sysctl.conf
    backup_file "/etc/sysctl.conf"

    # Optimize kernel parameters
    cat << EOF >> /etc/sysctl.conf
# Performance tweaks
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=5
vm.dirty_background_ratio=10
kernel.sched_migration_cost_ns=5000000
kernel.sched_autogroup_enabled=1
EOF
    sysctl -p >> "$LOG_FILE" 2>&1
    echo "Optimized kernel parameters" | tee -a "$LOG_FILE"

    # Disable unnecessary services (example: bluetooth, avahi)
    if command_exists systemctl; then
        systemctl disable bluetooth.service 2>/dev/null
        systemctl disable avahi-daemon.service 2>/dev/null
        echo "Disabled unnecessary services" | tee -a "$LOG_FILE"
    fi

    # Optimize filesystem mounts
    backup_file "/etc/fstab"
    if grep -q "ext4" /etc/fstab; then
        sed -i '/ext4/s/defaults/defaults,noatime,discard/' /etc/fstab
        echo "Added noatime,discard to ext4 mounts" | tee -a "$LOG_FILE"
    fi

    # Enable zram for better memory management
    if ! modprobe zram 2>/dev/null; then
        echo "zram not supported, skipping" | tee -a "$LOG_FILE"
    else
        echo 1 > /sys/block/zram0/reset 2>/dev/null
        echo $(( $(nproc) * 512 ))M > /sys/block/zram0/disksize 2>/dev/null
        mkswap /dev/zram0 >> "$LOG_FILE" 2>&1
        swapon /dev/zram0 >> "$LOG_FILE" 2>&1
        echo "Enabled zram swap" | tee -a "$LOG_FILE"
    fi
    
echo "Applying v2"
# CPU governor
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
    ORIGINAL_GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    echo "$ORIGINAL_GOVERNOR" > /tmp/original_governor
fi

# RAM swappiness
ORIGINAL_SWAPPINESS=$(sysctl -n vm.swappiness)
echo "$ORIGINAL_SWAPPINESS" > /tmp/original_swappiness
if grep -q "^vm.swappiness" /etc/sysctl.conf; then
    grep "^vm.swappiness" /etc/sysctl.conf > /tmp/original_swappiness_line
else
    touch /tmp/swappiness_added
fi

# HDD/SSD scheduler (assuming /dev/sda)
if [ -f /sys/block/sda/queue/scheduler ]; then
    ORIGINAL_SCHEDULER=$(cat /sys/block/sda/queue/scheduler | grep -o '\[.*\]' | tr -d '[]')
    echo "$ORIGINAL_SCHEDULER" > /tmp/original_scheduler
fi

# GRUB timeout
if grep -q "^GRUB_TIMEOUT=" /etc/default/grub; then
    ORIGINAL_GRUB_TIMEOUT=$(grep "^GRUB_TIMEOUT=" /etc/default/grub)
    echo "$ORIGINAL_GRUB_TIMEOUT" > /tmp/original_grub_timeout
fi

# CPU Tweak: Set governor to performance
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors ]; then
    if grep -q "performance" /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            echo "performance" > "$cpu"
        done
        echo "CPU governor set to performance."
    else
        echo "Performance governor not available. Skipping."
    fi
else
    echo "CPU frequency scaling not supported. Skipping."
fi

# RAM Tweak: Set swappiness to 10
sysctl -w vm.swappiness=10
if [ -f /tmp/original_swappiness_line ]; then
    sed -i "s/^vm.swappiness=.*/vm.swappiness=10/" /etc/sysctl.conf
else
    echo "vm.swappiness=10" >> /etc/sysctl.conf
fi
echo "Swappiness set to 10."

# HDD/SSD Tweak
if [ -f /sys/block/sda/queue/rotational ]; then
    if [ "$(cat /sys/block/sda/queue/rotational)" -eq 0 ]; then
        # SSD: Enable TRIM
        fstrim -a
        echo "TRIM enabled for SSD."
    else
        # HDD: Set scheduler to deadline
        if grep -q "deadline" /sys/block/sda/queue/scheduler; then
            echo "deadline" > /sys/block/sda/queue/scheduler
            echo "I/O scheduler set to deadline for HDD."
        else
            echo "Deadline scheduler not available. Skipping."
        fi
    fi
fi

# Clean Up: Remove junk files
apt-get clean
apt-get autoremove --purge -y
rm -rf /tmp/*
rm -rf /var/tmp/*
if command -v journalctl >/dev/null 2>&1; then
    journalctl --vacuum-time=7d
fi
echo "Clean up completed."

# Speed Up Boot: Reduce GRUB timeout
sed -i 's/GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=2/' /etc/default/grub
update-grub
echo "GRUB timeout set to 2 seconds."

# Disable Non-Critical Service (printer only if it exists)
if systemctl list-unit-files | grep -q printer.service; then
    systemctl disable printer.service
    echo "Printer service disabled."
else
    echo "Printer service not found. Skipping."
fi

# Fast App Launching: Alternative to missing tools
apt-get update
apt-get install -y preload haveged

# Preload
if systemctl list-unit-files | grep -q preload.service; then
    systemctl enable preload
    systemctl start preload
    echo "Preload enabled."
else
    echo "Preload service not found. Skipping."
fi

# haveged
if systemctl list-unit-files | grep -q haveged.service; then
    systemctl enable haveged
    systemctl start haveged
    echo "haveged enabled."
else
    echo "haveged service not found. Skipping."
fi

# zRAM Alternative: Manually configure zRAM
modprobe zram
echo lz4 > /sys/block/zram0/comp_algorithm
echo $(( $(grep MemTotal /proc/meminfo | awk '{print $2}') * 1024 / 2 )) > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon /dev/zram0
echo "zRAM configured manually."

echo "Optimization complete! Reboot to apply all changes."
}

# Function to restore previous settings
restore_settings() {
    echo "Restoring previous settings..." | tee -a "$LOG_FILE"



echo "Restoring system settings to defaults 2..."

# CPU Governor: Reset to powersave if available
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors ]; then
    if grep -q "powersave" /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            echo "powersave" > "$cpu"
        done
        echo "CPU governor reset to powersave."
    else
        echo "Powersave governor not available. Skipping."
    fi
else
    echo "CPU frequency scaling not supported. Skipping."
fi

# RAM Swappiness: Reset to default value (60)
sysctl -w vm.swappiness=60
sed -i '/^vm.swappiness=/d' /etc/sysctl.conf
echo "Swappiness reset to default (60)."

# HDD/SSD Scheduler: Reset to cfq (default for many systems)
if [ -f /sys/block/sda/queue/scheduler ]; then
    if grep -q "cfq" /sys/block/sda/queue/scheduler; then
        echo "cfq" > /sys/block/sda/queue/scheduler
        echo "I/O scheduler reset to cfq for /dev/sda."
    else
        echo "Default cfq scheduler not available. Skipping."
    fi
else
    echo "I/O scheduler configuration not found. Skipping."
fi

# GRUB Timeout: Reset to default (5 seconds)
if [ -f /etc/default/grub ]; then
    sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' /etc/default/grub
    update-grub
    echo "GRUB timeout reset to 5 seconds."
else
    echo "GRUB configuration file not found. Skipping."
fi

# Re-enable Non-Critical Services (printer)
if systemctl list-unit-files | grep -q printer.service; then
    systemctl enable printer.service
    echo "Printer service re-enabled."
fi

# Uninstall performance tools (if installed)
apt-get purge -y preload haveged
echo "Performance tools (preload, haveged) uninstalled."

# Disable zRAM (if enabled)
if grep -q zram /proc/devices; then
    if swapoff /dev/zram0 2>/dev/null; then
        echo "zRAM swap disabled."
    fi
    if [ -e /dev/zram0 ]; then
        echo 1 > /sys/block/zram0/reset
        echo "zRAM configuration reset."
    fi
else
    echo "zRAM not found. Skipping."
fi

# General Cleanup
rm -rf /tmp/*
rm -rf /var/tmp/*
echo "Temporary files cleaned up."

echo "System settings restored to defaults. A reboot is recommended."

    # Restore sysctl.conf
    latest_sysctl=$(ls -t "$BACKUP_DIR/sysctl.conf"* 2>/dev/null | head -n 1)
    if [ -f "$latest_sysctl" ]; then
        cp "$latest_sysctl" /etc/sysctl.conf
        sysctl -p >> "$LOG_FILE" 2>&1
        echo "Restored sysctl.conf" | tee -a "$LOG_FILE"
    else
        echo "No sysctl.conf backup found" | tee -a "$LOG_FILE"
    fi

    # Restore fstab
    latest_fstab=$(ls -t "$BACKUP_DIR/fstab"* 2>/dev/null | head -n 1)
    if [ -f "$latest_fstab" ]; then
        cp "$latest_fstab" /etc/fstab
        echo "Restored fstab" | tee -a "$LOG_FILE"
    else
        echo "No fstab backup found" | tee -a "$LOG_FILE"
    fi

    # Re-enable disabled services
    if command_exists systemctl; then
        systemctl enable bluetooth.service 2>/dev/null
        systemctl enable avahi-daemon.service 2>/dev/null
        echo "Re-enabled services" | tee -a "$LOG_FILE"
    fi

    # Disable zram
    if [ -b /dev/zram0 ]; then
        swapoff /dev/zram0 2>/dev/null
        modprobe -r zram 2>/dev/null
        echo "Disabled zram" | tee -a "$LOG_FILE"
    fi

    echo "Restoration complete. Reboot recommended." | tee -a "$LOG_FILE"
}

# Main logic
while true; do
    show_menu
    case $choice in
        1)
            clean_junk
            apply_tweaks
            echo "Optimization complete! Reboot recommended." | tee -a "$LOG_FILE"
            ;;
        2)
            restore_settings
            ;;
        3)
            echo "Exiting..." | tee -a "$LOG_FILE"
            exit 0
            ;;
        *)
            echo "Invalid option, try again." | tee -a "$LOG_FILE"
            ;;
    esac
done
