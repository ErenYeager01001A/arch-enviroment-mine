#!/bin/bash

# ==============================================================================
# Jasmin's MINIMAL Arch UI & SDDM Restorer (Black Screen Fix)
# ==============================================================================

echo -e "\e[1;32mWelcome to Minimal UI Restorer!\e[0m"
echo "This will restore your UI Environment (Hyprland, Bar, Widgets) and SDDM."
echo "No heavy software or images will be installed."
echo "------------------------------------------------------------------------------"

# 1. Base Setup
echo -e "\e[1;34m[1] Core UI Packages\e[0m"
read -p "Install Hyprland and UI dependencies? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
    sudo pacman -Syu --needed hyprland waybar kitty starship swaylock wlogout git base-devel sddm
    # Check for yay
    if ! command -v yay &> /dev/null; then
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm
        cd -
    fi
fi

# 2. Restore Configs
echo -e "\e[1;34m[2] Restoring UI Dotfiles\e[0m"
mkdir -p ~/.config
cp -rT configs/ ~/.config/
if [ -f "configs/bashrc.bak" ]; then cp configs/bashrc.bak ~/.bashrc; fi
if [ -f "configs/zshrc.bak" ]; then cp configs/zshrc.bak ~/.zshrc; fi
echo "UI Dotfiles restored."

# 3. SDDM Setup (To fix black screen)
echo -e "\e[1;34m[3] Setting up Login Screen (SDDM)\e[0m"
sudo mkdir -p /usr/share/sddm/themes/ /etc/sddm.conf.d/
if [ -d "sddm/sddm-astronaut-theme" ]; then
    sudo cp -rT sddm/sddm-astronaut-theme /usr/share/sddm/themes/sddm-astronaut-theme
fi
if [ -f "sddm/virtualkbd.conf" ]; then sudo cp sddm/virtualkbd.conf /etc/sddm.conf.d/; fi
if [ -f "sddm/sddm.conf" ]; then sudo cp sddm/sddm.conf /etc/; fi

# 4. Restore Single Wallpaper
echo -e "\e[1;34m[4] Restoring Default Wallpaper\e[0m"
mkdir -p ~/Pictures/Wallpapers
cp wallpapers/lloyd2.png ~/Pictures/Wallpapers/
echo "Wallpaper lloyd2.png restored."

# Force enable SDDM
sudo systemctl enable sddm.service -f
echo "SDDM enabled. Graphical login will show on next boot."

echo -e "\e[1;32m==============================================================================\e[0m"
echo "MINIMAL UI RESTORE COMPLETE!"
echo "Please REBOOT now. You should see the SDDM Astronaut login screen."
echo "=============================================================================="
