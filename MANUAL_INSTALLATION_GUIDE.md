# ML4W Hyprland Dotfiles - Manual Installation Guide

This guide provides step-by-step instructions to manually configure all components in the ML4W Hyprland dotfiles repository without using the automated installer.

> 💡 **Tip**: After completing the installation, use the included `validate-manual-setup.sh` script to verify your configuration is correct.

## ⚠️ Prerequisites

- Arch Linux, Fedora-based distribution, or NixOS
- Base Hyprland installation (recommended to test Hyprland first)
- Updated system packages
- Internet connection for package downloads
- For NixOS: Basic understanding of Nix configuration and flakes (if using flakes)

## 📋 Table of Contents

1. [Quick Start Guide](#quick-start-guide)
2. [System Requirements](#system-requirements)
3. [Package Installation](#package-installation)
4. [Configuration Files Setup](#configuration-files-setup)
5. [Theme and Font Installation](#theme-and-font-installation)
6. [Service Configuration](#service-configuration)
7. [Application-Specific Configuration](#application-specific-configuration)
8. [Final Steps](#final-steps)
9. [Troubleshooting](#troubleshooting)
10. [Additional Customization](#additional-customization)
11. [Updates and Maintenance](#updates-and-maintenance)
12. [Essential Configuration Examples](#essential-configuration-examples)

## 🚀 Quick Start Guide

If you're experienced with Linux and want to get up and running quickly:

### For Arch Linux:
```bash
# 1. Install packages
sudo pacman -S hyprland hyprpaper hyprlock hypridle xdg-desktop-portal-hyprland kitty waybar rofi-wayland swaync wlogout polkit-gnome python-pywal
yay -S grimblast-git bibata-cursor-theme-bin oh-my-posh-bin

# 2. Get the dotfiles
git clone https://github.com/elbasel-404/dotfiles-l4w.git ~/.ml4w-hyprland/dotfiles
cd ~/.ml4w-hyprland/dotfiles

# 3. Copy configurations
cp -r share/dotfiles/.config/* ~/.config/
cp share/dotfiles/.zshrc ~/.zshrc

# 4. Setup directories and permissions
mkdir -p ~/.config/ml4w/settings ~/.ml4w-hyprland/{backup,archive,log}
find ~/.config/hypr/scripts -name "*.sh" -exec chmod +x {} \;
find ~/.config/ml4w -name "*.sh" -exec chmod +x {} \;

# 5. Initialize wallpaper system
mkdir -p ~/Pictures/wallpapers && cp -r share/wallpapers/* ~/Pictures/wallpapers/
wal --theme base16-default-dark

# 6. Start Hyprland
Hyprland
```

### For NixOS:
```bash
# 1. Enable Hyprland in your NixOS configuration (see NixOS section below for details)
# 2. Get the dotfiles
git clone https://github.com/elbasel-404/dotfiles-l4w.git ~/.ml4w-hyprland/dotfiles
cd ~/.ml4w-hyprland/dotfiles

# 3. Copy configurations (NixOS users may prefer Home Manager - see detailed section)
cp -r share/dotfiles/.config/* ~/.config/
cp share/dotfiles/.zshrc ~/.zshrc

# 4. Setup directories and permissions
mkdir -p ~/.config/ml4w/settings ~/.ml4w-hyprland/{backup,archive,log}
find ~/.config/hypr/scripts -name "*.sh" -exec chmod +x {} \;
find ~/.config/ml4w -name "*.sh" -exec chmod +x {} \;

# 5. Initialize wallpaper system
mkdir -p ~/Pictures/wallpapers && cp -r share/wallpapers/* ~/Pictures/wallpapers/
nix-shell -p python3Packages.pywal --run "wal --theme base16-default-dark"

# 6. Start Hyprland (if not configured as default session)
Hyprland
```

### For Fedora:
```bash
# 1. Install packages  
sudo dnf install hyprland hyprpaper hyprlock hypridle xdg-desktop-portal-hyprland kitty waybar rofi-wayland SwayNotificationCenter wlogout polkit-gnome python3-pywal

# 2-6. Follow the same steps as Arch Linux above
```

> **Note**: The quick start assumes you understand Linux systems. For detailed explanations, continue reading the full guide below.
> 
> **NixOS Users**: The NixOS quick start above is simplified. NixOS users should read the full NixOS section (2.3) for proper declarative configuration.

## 1. System Requirements

### Base Dependencies
Before starting, ensure you have a working base system with these core components:
- Linux kernel with wayland support
- Basic development tools (git, make, gcc)
- Package manager (pacman for Arch, dnf for Fedora)

## 2. Package Installation

### 2.1 Arch Linux Package Installation

#### Core Hyprland Packages
```bash
# Install core Hyprland components
sudo pacman -S hyprland hyprpaper hyprlock hypridle hyprpicker
sudo pacman -S xdg-desktop-portal-hyprland libnotify
sudo pacman -S qt5-wayland qt6-wayland uwsm
```

#### Font Packages
```bash
# Install required fonts
sudo pacman -S noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra
sudo pacman -S ttf-fira-sans ttf-fira-code ttf-dejavu
```

#### Desktop Environment Packages
```bash
# Install desktop components
sudo pacman -S kitty waybar rofi-wayland swaync wlogout
sudo pacman -S polkit-gnome network-manager-applet nm-connection-editor
sudo pacman -S brightnessctl pavucontrol blueman
sudo pacman -S gtk4 libadwaita qt6ct nwg-look
sudo pacman -S grim slurp cliphist imagemagick jq xclip
sudo pacman -S papirus-icon-theme breeze flatpak gvfs
```

#### Development and Utility Packages
```bash
# Install development and utility tools
sudo pacman -S fastfetch eza python-pip python-gobject python-screeninfo
sudo pacman -S tumbler fuse2 neovim htop python-pywal pinta
sudo pacman -S zsh zsh-completions fzf hyprshade waypaper
sudo pacman -S loupe power-profiles-daemon
```

#### AUR Packages (requires AUR helper like yay or paru)
```bash
# Install AUR helper first (example with yay)
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# Install AUR packages
yay -S grimblast-git bibata-cursor-theme-bin pacseek
yay -S ttf-firacode-nerd nwg-dock-hyprland oh-my-posh-bin
yay -S checkupdates-with-aur otf-font-awesome
```

### 2.2 Fedora Linux Package Installation

#### Enable Required Repositories
```bash
# Enable RPM Fusion repositories
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

#### Core Hyprland Packages
```bash
# Install Hyprland and core components
sudo dnf install hyprland hyprpaper hyprlock hypridle
sudo dnf install xdg-desktop-portal-hyprland libnotify
sudo dnf install qt5-qtwayland qt6-qtwayland
```

#### Desktop Environment Packages
```bash
# Install desktop components
sudo dnf install kitty waybar rofi-wayland SwayNotificationCenter wlogout
sudo dnf install polkit-gnome NetworkManager-applet nm-connection-editor
sudo dnf install brightnessctl pavucontrol blueman
sudo dnf install gtk4-devel libadwaita qt6ct
sudo dnf install grim slurp ImageMagick jq xclip
sudo dnf install papirus-icon-theme flatpak
```

#### Additional Fedora Packages
```bash
# Install additional utilities
sudo dnf install fastfetch eza python3-pip python3-gobject
sudo dnf install tumbler fuse neovim htop python3-pywal
sudo dnf install zsh zsh-completions fzf
sudo dnf install google-noto-fonts google-noto-emoji-fonts
sudo dnf install fira-sans-fonts fira-code-fonts dejavu-fonts
```

### 2.3 NixOS Package Installation

NixOS uses a declarative configuration approach. You can install packages either system-wide via `/etc/nixos/configuration.nix` or per-user via Home Manager.

#### System-wide Installation (recommended for Hyprland)

Add the following to your `/etc/nixos/configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # System packages for ML4W Hyprland setup
  environment.systemPackages = with pkgs; [
    # Core Hyprland ecosystem
    hyprland
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    xdg-desktop-portal-hyprland
    
    # Terminal and shell
    kitty
    zsh
    zsh-completions
    oh-my-posh
    
    # Desktop components
    waybar
    rofi-wayland
    swaynotificationcenter
    wlogout
    
    # Utilities
    brightnessctl
    pavucontrol
    blueman
    networkmanagerapplet
    polkit_gnome
    
    # Graphics and screenshots
    grim
    slurp
    imagemagick
    cliphist
    
    # Themes and fonts
    papirus-icon-theme
    bibata-cursors
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    fira-code
    fira-code-nerdfont
    dejavu_fonts
    font-awesome
    
    # Development and utilities
    fastfetch
    eza
    neovim
    htop
    git
    jq
    xclip
    python3Packages.pywal
    python3Packages.gobject3
    
    # File management
    thunar
    tumbler
    gvfs
    
    # Additional tools
    libnotify
    qt5.qtwayland
    qt6.qtwayland
    gtk4
    libadwaita
    nwg-look
    qt6ct
    
    # Optional applications
    firefox  # or your preferred browser
    # discord
    # spotify
  ];

  # Enable services
  services = {
    # Display manager (optional - you can also start Hyprland from TTY)
    displayManager = {
      sddm.enable = true;
      defaultSession = "hyprland";
    };
    
    # Essential services
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    
    dbus.enable = true;
    blueman.enable = true;
  };

  # Enable polkit
  security.polkit.enable = true;
  
  # Enable zsh system-wide
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;  # Optional: make zsh default for all users
}
```

#### Using Home Manager (alternative approach)

If you prefer per-user configuration, you can use Home Manager. First, install Home Manager, then add to your `home.nix`:

```nix
{ config, pkgs, ... }:

{
  # User packages
  home.packages = with pkgs; [
    # Core applications (assuming Hyprland is enabled system-wide)
    kitty
    waybar
    rofi-wayland
    swaynotificationcenter
    wlogout
    
    # Utilities and tools
    brightnessctl
    pavucontrol
    grim
    slurp
    cliphist
    python3Packages.pywal
    fastfetch
    eza
    neovim
    htop
    
    # Fonts and themes
    bibata-cursors
    fira-code-nerdfont
    font-awesome
  ];

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # Add your zsh configuration here
  };

  # Git configuration (recommended)
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };
}
```

#### NixOS Installation Steps

```bash
# 1. Edit your NixOS configuration
sudo nano /etc/nixos/configuration.nix

# 2. Add the packages and configuration shown above

# 3. Rebuild your system
sudo nixos-rebuild switch

# 4. Reboot (recommended after major changes)
sudo reboot
```

#### Using Nix Flakes (Advanced)

If you use flakes, create a `flake.nix`:

```nix
{
  description = "ML4W Hyprland NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, hyprland, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        hyprland.nixosModules.default
        ./configuration.nix
        {
          programs.hyprland.enable = true;
        }
      ];
    };
  };
}
```

## 3. Configuration Files Setup

### 3.1 Backup Existing Configurations
```bash
# Create backup directory
mkdir -p ~/.config-backup/$(date +%Y%m%d_%H%M%S)

# Backup existing configurations if they exist
for config in hypr waybar kitty rofi swaync wlogout dunst; do
    if [ -d ~/.config/$config ]; then
        cp -r ~/.config/$config ~/.config-backup/$(date +%Y%m%d_%H%M%S)/
    fi
done
```

### 3.2 Clone and Setup Configuration Files

#### For Traditional Linux Distributions (Arch/Fedora)
```bash
# Create working directory
mkdir -p ~/.ml4w-hyprland
cd ~/.ml4w-hyprland

# Clone the repository (replace with your preferred method)
git clone https://github.com/elbasel-404/dotfiles-l4w.git dotfiles
cd dotfiles

# Copy configuration files
cp -r share/dotfiles/.config/* ~/.config/
cp -r share/dotfiles/.bashrc ~/.bashrc
cp -r share/dotfiles/.zshrc ~/.zshrc
cp share/dotfiles/.gtkrc-2.0 ~/.gtkrc-2.0
cp share/dotfiles/.Xresources ~/.Xresources
```

#### For NixOS Users

NixOS users have two options:

**Option 1: Direct file copying (simpler)**
```bash
# Same as above - copy files directly to ~/.config
mkdir -p ~/.ml4w-hyprland
cd ~/.ml4w-hyprland
git clone https://github.com/elbasel-404/dotfiles-l4w.git dotfiles
cd dotfiles
cp -r share/dotfiles/.config/* ~/.config/
cp share/dotfiles/.zshrc ~/.zshrc
```

**Option 2: Using Home Manager (recommended for NixOS)**
```nix
# Add to your home.nix file
{ config, pkgs, ... }:

{
  # Copy ML4W dotfiles using Home Manager
  home.file = {
    ".config/hypr".source = /path/to/dotfiles-l4w/share/dotfiles/.config/hypr;
    ".config/waybar".source = /path/to/dotfiles-l4w/share/dotfiles/.config/waybar;
    ".config/rofi".source = /path/to/dotfiles-l4w/share/dotfiles/.config/rofi;
    ".config/swaync".source = /path/to/dotfiles-l4w/share/dotfiles/.config/swaync;
    ".config/kitty".source = /path/to/dotfiles-l4w/share/dotfiles/.config/kitty;
    ".config/wlogout".source = /path/to/dotfiles-l4w/share/dotfiles/.config/wlogout;
    ".config/dunst".source = /path/to/dotfiles-l4w/share/dotfiles/.config/dunst;
    ".config/ml4w".source = /path/to/dotfiles-l4w/share/dotfiles/.config/ml4w;
    ".zshrc".source = /path/to/dotfiles-l4w/share/dotfiles/.zshrc;
  };
  
  # Alternative: use home.activation to run setup commands
  home.activation.ml4wSetup = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.ml4w-hyprland/{backup,archive,log}
    echo "nixos" > ~/.config/ml4w/settings/platform.sh
    echo "dotfiles" > ~/.config/ml4w/settings/dotfiles-folder.sh
  '';
}
```

### 3.3 Setup ML4W Directory Structure
```bash
# Create ML4W directories
mkdir -p ~/.config/ml4w/settings
mkdir -p ~/.ml4w-hyprland/{backup,archive,log}

# Set up basic ML4W settings
echo "dotfiles" > ~/.config/ml4w/settings/dotfiles-folder.sh

# Set platform (choose appropriate one)
echo "arch" > ~/.config/ml4w/settings/platform.sh     # for Arch
echo "fedora" > ~/.config/ml4w/settings/platform.sh   # for Fedora  
echo "nixos" > ~/.config/ml4w/settings/platform.sh    # for NixOS

# For Arch users - set AUR helper
echo "yay" > ~/.config/ml4w/settings/aur.sh           # or "paru", etc.

# For NixOS users - this step is not needed as packages are managed declaratively
```

## 4. Theme and Font Installation

### 4.1 Install Custom Fonts
```bash
# Create fonts directory
mkdir -p ~/.local/share/fonts

# Copy custom fonts from the repository
cp -r share/fonts/* ~/.local/share/fonts/

# Update font cache
fc-cache -fv
```

### 4.2 Setup Cursor Theme
```bash
# Ensure cursor theme is installed (Bibata)
# This should be installed via AUR package above
# Set cursor theme in ~/.config/hypr/conf/cursor.conf
```

### 4.3 Install Wallpapers
```bash
# Create wallpapers directory
mkdir -p ~/Pictures/wallpapers

# Copy wallpapers
cp -r share/wallpapers/* ~/Pictures/wallpapers/
```

## 5. Service Configuration

### 5.1 Enable Required Services

#### For Arch Linux and Fedora:
```bash
# Enable NetworkManager (if not already enabled)
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Enable Bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Enable power-profiles-daemon (for laptop power management)
sudo systemctl enable power-profiles-daemon
sudo systemctl start power-profiles-daemon
```

#### For NixOS:
Services are enabled declaratively in your configuration. The configuration provided in section 2.3 already includes the necessary services. If you need to enable additional services, add them to your `/etc/nixos/configuration.nix`:

```nix
{
  services = {
    # Already included in the main config
    pipewire.enable = true;
    blueman.enable = true;
    
    # Additional services you might want
    power-profiles-daemon.enable = true;  # for laptop power management
    
    # NetworkManager is usually enabled by default on NixOS desktop
    networkmanager.enable = true;
  };
}
```

Then rebuild: `sudo nixos-rebuild switch`

### 5.2 Setup User Services

#### For Arch Linux and Fedora:
```bash
# Enable user services for Hyprland session
systemctl --user enable xdg-desktop-portal-hyprland
```

#### For NixOS:
User services are automatically configured when you enable Hyprland in your system configuration. No manual user service setup is required.

### 5.3 Setup Display Manager

#### For Arch Linux and Fedora:
```bash
# Install SDDM
sudo pacman -S sddm  # Arch
# or
sudo dnf install sddm  # Fedora

# Enable SDDM
sudo systemctl enable sddm

# Copy SDDM theme (if available)
if [ -d share/sddm ]; then
    sudo cp -r share/sddm/* /usr/share/sddm/themes/
fi
```

#### For NixOS:
SDDM configuration is done declaratively. Add to your `/etc/nixos/configuration.nix`:

```nix
{
  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "hyprland";
    };
  };
  
  # Optional: SDDM theme configuration
  services.xserver.displayManager.sddm.theme = "breeze";  # or your preferred theme
}
```

Or you can start Hyprland directly from a TTY without a display manager.

## 6. Application-Specific Configuration

### 6.1 Shell Configuration (ZSH)
```bash
# Install Oh My Zsh (optional but recommended)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Change default shell to zsh
chsh -s $(which zsh)

# Install Oh My Posh for shell theming
# On Arch:
yay -S oh-my-posh-bin
# On Fedora:
curl -s https://ohmyposh.dev/install.sh | bash -s

# The .zshrc file should already be copied, but ensure it's configured correctly
source ~/.zshrc
```

### 6.2 Hyprland Configuration
```bash
# Ensure all Hyprland config files are in place
ls ~/.config/hypr/

# Key files that should be present:
# - hyprland.conf (main configuration)
# - conf/ directory with modular configs
# - scripts/ directory with utility scripts
# - hyprpaper.conf, hyprlock.conf, hypridle.conf

# Make all scripts executable
find ~/.config/hypr/scripts -name "*.sh" -exec chmod +x {} \;

# Key configuration files explained:
# ~/.config/hypr/hyprland.conf - Main Hyprland configuration
# ~/.config/hypr/conf/autostart.conf - Applications to start with Hyprland
# ~/.config/hypr/conf/keybindings/default.conf - Keyboard shortcuts
# ~/.config/hypr/conf/monitor.conf - Monitor configuration
# ~/.config/hypr/conf/environment.conf - Environment variables

# Test Hyprland configuration
hyprctl reload
```

### 6.3 Waybar Configuration
```bash
# Waybar should be configured with multiple themes
ls ~/.config/waybar/themes/

# Ensure the main config points to your preferred theme
# Edit ~/.config/waybar/config.jsonc if needed
```

### 6.4 Application Launcher (Rofi)
```bash
# Rofi configuration should be set up
ls ~/.config/rofi/

# Test rofi
rofi -show drun
```

### 6.5 Notification System (SwayNC)
```bash
# SwayNC configuration
ls ~/.config/swaync/

# Test notifications
notify-send "Test" "Notification system working"
```

## 7. Final Steps

### 7.1 Set Executable Permissions
```bash
# Make scripts executable
find ~/.config/hypr/scripts -name "*.sh" -exec chmod +x {} \;
find ~/.config/waybar/scripts -name "*.sh" -exec chmod +x {} \;
find ~/.config/ml4w -name "*.sh" -exec chmod +x {} \;
```

### 7.2 Initialize Pywal (Color Scheme)
```bash
# Create default wallpapers directory if it doesn't exist
mkdir -p ~/Pictures/wallpapers

# Initialize pywal with a default wallpaper
# Find a wallpaper from the copied wallpapers
WALLPAPER=$(find ~/Pictures/wallpapers -name "*.jpg" -o -name "*.png" | head -1)
if [ -n "$WALLPAPER" ]; then
    wal -i "$WALLPAPER"
else
    # If no wallpapers found, use a solid color
    wal --theme base16-default-dark
fi

# Generate pywal colors for Hyprland
# This creates ~/.cache/wal/colors-hyprland.conf which is sourced by hyprland.conf

# Or use waypaper for GUI wallpaper management
waypaper --restore  # Restore last wallpaper if available
```

### 7.3 Setup GTK Themes
```bash
# Use nwg-look to configure GTK themes
nwg-look

# Or manually set in ~/.config/gtk-3.0/settings.ini and ~/.config/gtk-4.0/settings.ini
```

### 7.4 Setup Critical Scripts and Permissions
```bash
# Make ML4W scripts executable
find ~/.config/ml4w -name "*.sh" -exec chmod +x {} \;

# Create missing script files if they don't exist
mkdir -p ~/.config/ml4w/settings

# Create terminal script if missing
if [ ! -f ~/.config/ml4w/settings/terminal.sh ]; then
    echo '#!/bin/bash' > ~/.config/ml4w/settings/terminal.sh
    echo 'kitty' >> ~/.config/ml4w/settings/terminal.sh
    chmod +x ~/.config/ml4w/settings/terminal.sh
fi

# Create browser script if missing
if [ ! -f ~/.config/ml4w/settings/browser.sh ]; then
    echo '#!/bin/bash' > ~/.config/ml4w/settings/browser.sh
    echo 'firefox' >> ~/.config/ml4w/settings/browser.sh  # or your preferred browser
    chmod +x ~/.config/ml4w/settings/browser.sh
fi

# Create file manager script if missing
if [ ! -f ~/.config/ml4w/settings/filemanager.sh ]; then
    echo '#!/bin/bash' > ~/.config/ml4w/settings/filemanager.sh
    echo 'thunar' >> ~/.config/ml4w/settings/filemanager.sh  # or your preferred file manager
    chmod +x ~/.config/ml4w/settings/filemanager.sh
fi

# Setup polkit agent for authentication dialogs
# This should auto-start from autostart.conf, but verify it's running:
pgrep -f polkit-gnome-authentication-agent-1 || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
```
```bash
# Create desktop entry if it doesn't exist
cat > ~/.local/share/wayland-sessions/hyprland.desktop << EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
```

### 7.5 Create Desktop Entry for Hyprland
```bash
# Create desktop entry if it doesn't exist
cat > ~/.local/share/wayland-sessions/hyprland.desktop << EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
```

### 7.6 Test Configuration
```bash
# Use the included validation script to check your setup
./validate-manual-setup.sh

# Or manually test key components:
# Log out and log back into Hyprland session
# Or if already in Hyprland, reload configuration:
hyprctl reload

# Test individual applications
rofi -show drun                    # Should show application launcher
notify-send "Test" "Notification"  # Should show notification  
waybar &                          # Should start status bar
swaync-client -t                  # Should toggle notification center
```

## 8. Troubleshooting

### 8.1 Common Issues

#### Hyprland won't start
- Check logs: `journalctl -u hyprland`
- Ensure graphics drivers are properly installed
- Verify all dependencies are installed

#### Applications don't launch
- Check if xdg-desktop-portal-hyprland is running
- Verify PATH includes necessary directories
- Check application-specific logs

#### Themes not applying
- Run `fc-cache -fv` to rebuild font cache
- Ensure GTK themes are properly installed
- Check cursor theme installation

#### Waybar not showing
- Check waybar configuration syntax
- Verify all waybar modules have required dependencies
- Check waybar logs: `waybar -l debug`

### 8.2 Useful Commands

```bash
# Reload Hyprland configuration
hyprctl reload

# Check Hyprland version and info
hyprctl version

# List active windows
hyprctl clients

# Check running services
systemctl --user status xdg-desktop-portal-hyprland
systemctl --user status hyprland-session.target

# Test individual components
waybar &
rofi -show drun
swaync-client -t
```

### 8.3 NixOS-Specific Issues

#### Hyprland not starting
- Ensure Hyprland is enabled in `/etc/nixos/configuration.nix`
- Check if you ran `sudo nixos-rebuild switch` after configuration changes
- Verify XDG portals are configured correctly

#### Packages not found
- NixOS packages may have different names than Arch/Fedora
- Use `nix search nixpkgs <package-name>` to find the correct package name
- Some packages may be in unstable channel - consider using `nixos-unstable`

#### Home Manager conflicts
- If using both system packages and Home Manager, avoid duplicate package declarations
- Use `home-manager generations` to see previous configurations
- Use `home-manager switch --rollback` to revert problematic changes

#### Configuration rebuild fails
```bash
# Check for syntax errors
sudo nixos-rebuild dry-build

# Build without switching (test configuration)
sudo nixos-rebuild build

# Check what would change
sudo nixos-rebuild dry-activate
```

#### Graphics/Wayland issues on NixOS
- Ensure your graphics drivers are properly configured in NixOS
- For NVIDIA: enable `hardware.nvidia.modesetting.enable = true`
- For AMD/Intel: ensure proper kernel module loading

### 8.4 Log Files Locations
- Hyprland: `~/.local/share/hyprland/hyprland.log`
- Waybar: Check terminal output when running `waybar`
- X11 applications: `~/.xsession-errors`

## 9. Additional Customization

### 9.1 Keybindings
Edit `~/.config/hypr/conf/keybinding.conf` to customize keyboard shortcuts.

### 9.2 Monitor Configuration
Edit `~/.config/hypr/conf/monitor.conf` for multi-monitor setups.

### 9.3 Startup Applications
Edit `~/.config/hypr/conf/autostart.conf` to add/remove startup applications.

### 9.4 Custom Scripts
Add custom scripts to `~/.config/hypr/scripts/` and make them executable.

## 10. Updates and Maintenance

### 10.1 Updating Configuration
```bash
# Update dotfiles repository
cd ~/.ml4w-hyprland/dotfiles
git pull origin main

# Manually merge new configurations as needed
# Always backup your custom changes first
```

### 10.2 Package Updates
```bash
# Arch Linux
sudo pacman -Syu
yay -Syu

# Fedora
sudo dnf update

# NixOS
sudo nixos-rebuild switch --upgrade    # Updates system packages
# or for flakes:
sudo nixos-rebuild switch --upgrade --flake .

# If using Home Manager:
home-manager switch --upgrade
```

## 11. Essential Configuration Examples

### 11.1 Hyprland Keybindings (Key shortcuts you should know)
After setup, these are the default keybindings:

```
SUPER + RETURN        - Open terminal
SUPER + B             - Open browser  
SUPER + E             - Open file manager
SUPER + Q             - Close active window
SUPER + F             - Toggle fullscreen
SUPER + T             - Toggle floating window
SUPER + SPACE         - Open application launcher (rofi)
SUPER + SHIFT + S     - Take screenshot
SUPER + L             - Lock screen
SUPER + CTRL + Q      - Open logout menu (wlogout)
SUPER + 1-9           - Switch to workspace 1-9
SUPER + SHIFT + 1-9   - Move window to workspace 1-9
SUPER + Arrow Keys    - Move focus between windows
SUPER + SHIFT + Arrow - Resize active window
SUPER + ALT + Arrow   - Swap windows
```

### 11.2 First Launch Checklist
After completing the installation, perform these checks:

```bash
# 1. Verify Hyprland can start (do this from a TTY or existing session)
Hyprland --dry-run

# 2. Check if all required services are running after login to Hyprland
systemctl --user status xdg-desktop-portal-hyprland
pgrep -f "waybar"
pgrep -f "swaync"
pgrep -f "hyprpaper"

# 3. Test key applications
rofi -show drun                    # Should show application launcher
notify-send "Test" "Message"       # Should show notification
hyprpicker                        # Should allow color picking
```

### 11.3 Monitor Configuration Example
Edit `~/.config/hypr/conf/monitor.conf`:

```bash
# Example for single 1920x1080 monitor
monitor=,1920x1080@60,0x0,1

# Example for dual monitor setup (adjust as needed)
monitor=DP-1,1920x1080@60,0x0,1
monitor=HDMI-A-1,1920x1080@60,1920x0,1

# For laptop with external monitor
monitor=eDP-1,1920x1080@60,0x0,1
monitor=HDMI-A-1,1920x1080@60,1920x0,1

# Auto-detect monitors (recommended for laptops)
monitor=,preferred,auto,1
```

### 11.4 Startup Applications Configuration
Edit `~/.config/hypr/conf/autostart.conf` to customize what starts with Hyprland:

```bash
# Essential services (keep these)
exec-once = ~/.config/hypr/scripts/xdg.sh
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = ~/.config/hypr/scripts/wallpaper-restore.sh
exec-once = swaync
exec-once = ~/.config/hypr/scripts/gtk.sh
exec-once = hypridle
exec-once = wl-paste --watch cliphist store

# Optional applications (add/remove as needed)
exec-once = waybar
exec-once = nm-applet
exec-once = blueman-applet
# exec-once = discord
# exec-once = spotify
```

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [ML4W Dotfiles GitHub](https://github.com/mylinuxforwork/dotfiles)
- [ML4W Discord Server](https://discord.gg/c4fJK7Za3g)

## ⚠️ Important Notes

1. **Backup First**: Always backup your existing configurations before proceeding
2. **Test Components**: Test each component individually before proceeding to the next
3. **Custom Variations**: Create custom configuration variations instead of modifying the base files
4. **Distribution Differences**: Some packages may have different names or availability on different distributions
5. **Hardware Specific**: Some configurations may need adjustment based on your hardware (especially graphics drivers)

This manual installation process gives you complete control over your Hyprland setup but requires more technical knowledge than the automated installer. Take your time with each step and don't hesitate to refer to the official documentation for each component.