#!/bin/bash
# ML4W Hyprland Manual Setup Validation Script
# This script helps validate that your manual installation is correct

echo "🔍 ML4W Hyprland Manual Setup Validation"
echo "========================================"
echo

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a command exists
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        return 1
    fi
}

# Function to check if a file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 exists"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is missing"
        return 1
    fi
}

# Function to check if a directory exists
check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 directory exists"
        return 0
    else
        echo -e "${RED}✗${NC} $1 directory is missing"
        return 1
    fi
}

# Function to check if a service is running
check_service() {
    if systemctl --user is-active --quiet "$1" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $1 service is running"
        return 0
    else
        echo -e "${YELLOW}!${NC} $1 service is not running (may be normal if not in Hyprland session)"
        return 1
    fi
}

echo "Checking core Hyprland components..."
echo "-----------------------------------"
check_command "hyprland"
check_command "hyprpaper"
check_command "hyprlock"
check_command "hypridle"
echo

echo "Checking desktop applications..."
echo "-------------------------------"
check_command "kitty"
check_command "waybar"
check_command "rofi"
check_command "swaync"
check_command "wlogout"
check_command "wal"
check_command "waypaper"
echo

echo "Checking configuration files..."
echo "------------------------------"
check_file "$HOME/.config/hypr/hyprland.conf"
check_file "$HOME/.config/hypr/conf/autostart.conf"
check_file "$HOME/.config/hypr/conf/keybindings/default.conf"
check_file "$HOME/.config/waybar/config.jsonc"
check_file "$HOME/.config/rofi/config.rasi"
check_file "$HOME/.config/swaync/config.json"
check_file "$HOME/.zshrc"
echo

echo "Checking directory structure..."
echo "------------------------------"
check_directory "$HOME/.config/hypr"
check_directory "$HOME/.config/hypr/scripts"
check_directory "$HOME/.config/waybar"
check_directory "$HOME/.config/ml4w"
check_directory "$HOME/.ml4w-hyprland"
echo

echo "Checking script permissions..."
echo "-----------------------------"
if [ -d "$HOME/.config/hypr/scripts" ]; then
    script_count=$(find "$HOME/.config/hypr/scripts" -name "*.sh" -executable | wc -l)
    total_scripts=$(find "$HOME/.config/hypr/scripts" -name "*.sh" | wc -l)
    echo -e "${GREEN}✓${NC} $script_count of $total_scripts Hyprland scripts are executable"
else
    echo -e "${RED}✗${NC} Hyprland scripts directory not found"
fi

if [ -d "$HOME/.config/ml4w" ]; then
    ml4w_script_count=$(find "$HOME/.config/ml4w" -name "*.sh" -executable 2>/dev/null | wc -l)
    if [ $ml4w_script_count -gt 0 ]; then
        echo -e "${GREEN}✓${NC} $ml4w_script_count ML4W scripts are executable"
    else
        echo -e "${YELLOW}!${NC} No executable ML4W scripts found (this may be normal)"
    fi
fi
echo

echo "Checking fonts..."
echo "----------------"
if fc-list | grep -q "Fira Code"; then
    echo -e "${GREEN}✓${NC} Fira Code font is available"
else
    echo -e "${YELLOW}!${NC} Fira Code font not found"
fi

if fc-list | grep -q "Font Awesome"; then
    echo -e "${GREEN}✓${NC} Font Awesome is available"
else
    echo -e "${YELLOW}!${NC} Font Awesome not found"
fi
echo

echo "Checking wallpaper setup..."
echo "--------------------------"
check_directory "$HOME/Pictures/wallpapers"
if [ -f "$HOME/.cache/wal/colors-hyprland.conf" ]; then
    echo -e "${GREEN}✓${NC} Pywal colors generated"
else
    echo -e "${YELLOW}!${NC} Pywal colors not generated - run 'wal -i /path/to/wallpaper'"
fi
echo

echo "Checking services (only relevant if running in Hyprland)..."
echo "---------------------------------------------------------"
if [ "$XDG_CURRENT_DESKTOP" = "hyprland" ] || [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    check_service "xdg-desktop-portal-hyprland"
    
    # Check if key processes are running
    if pgrep -f "waybar" >/dev/null; then
        echo -e "${GREEN}✓${NC} Waybar is running"
    else
        echo -e "${YELLOW}!${NC} Waybar is not running"
    fi
    
    if pgrep -f "swaync" >/dev/null; then
        echo -e "${GREEN}✓${NC} SwayNC is running"
    else
        echo -e "${YELLOW}!${NC} SwayNC is not running"
    fi
    
    if pgrep -f "hyprpaper" >/dev/null; then
        echo -e "${GREEN}✓${NC} Hyprpaper is running"
    else
        echo -e "${YELLOW}!${NC} Hyprpaper is not running"
    fi
else
    echo -e "${YELLOW}!${NC} Not currently in a Hyprland session - service checks skipped"
fi
echo

echo "Testing key functions..."
echo "-----------------------"
if command -v rofi >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} You can test the application launcher with: rofi -show drun"
fi

if command -v notify-send >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} You can test notifications with: notify-send 'Test' 'Message'"
fi

if command -v hyprctl >/dev/null 2>&1 && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo -e "${GREEN}✓${NC} You can reload Hyprland config with: hyprctl reload"
fi
echo

echo "🎉 Validation complete!"
echo "======================"
echo "If you see mostly green checkmarks, your manual installation is likely correct."
echo "Yellow warnings (!) may be normal depending on your system state."
echo "Red errors (✗) indicate missing components that should be installed/configured."
echo
echo "To start Hyprland: run 'Hyprland' from a TTY or select it from your display manager."
echo "Key shortcuts to remember:"
echo "  SUPER + RETURN  - Terminal"
echo "  SUPER + SPACE   - App launcher" 
echo "  SUPER + Q       - Close window"
echo "  SUPER + L       - Lock screen"
echo "  SUPER + CTRL + Q - Logout menu"