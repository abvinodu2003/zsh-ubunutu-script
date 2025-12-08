#!/bin/bash

set -e

echo "=== Switching shell back to bash ==="
if [ "$SHELL" != "/usr/bin/bash" ]; then
    chsh -s /usr/bin/bash
fi

echo "=== Removing Oh-My-Zsh installation ==="
rm -rf ~/.oh-my-zsh

echo "=== Removing Powerlevel10k config ==="
rm -f ~/.p10k.zsh

echo "=== Removing .zshrc ==="
rm -f ~/.zshrc

echo "=== Removing Zsh cache (instant prompt) ==="
rm -f ~/.cache/p10k-instant-prompt-*.zsh

echo "=== Removing MesloLGS Nerd Fonts installed for P10K ==="
FONT_DIR="$HOME/.local/share/fonts"
rm -f "$FONT_DIR/MesloLGS NF Regular.ttf"
rm -f "$FONT_DIR/MesloLGS NF Bold.ttf"
rm -f "$FONT_DIR/MesloLGS NF Italic.ttf"
rm -f "$FONT_DIR/MesloLGS NF Bold Italic.ttf"

fc-cache -f

echo "=== Optional: uninstall zsh package? ==="
read -p "Do you want to uninstall the zsh package itself? (y/n): " ANSWER

if [[ "$ANSWER" == "y" || "$ANSWER" == "Y" ]]; then
    sudo apt remove --purge -y zsh
    sudo apt autoremove -y
    echo "Zsh package removed."
else
    echo "Skipping zsh package removal."
fi

echo "=== Uninstallation complete! ==="
echo "➡ Restart your terminal session."
echo "➡ System is ready for a clean reinstall."
