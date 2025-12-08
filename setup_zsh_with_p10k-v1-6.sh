#!/bin/bash

set -e

echo "=== Installing Zsh ==="
sudo apt update
sudo apt install -y zsh git curl

echo "=== Making Zsh the default shell ==="
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
fi

echo "=== Installing Oh-My-Zsh ==="
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "=== Installing Powerlevel10k ==="
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

echo "=== Installing plugins (autosuggestions + syntax highlighting) ==="
AUTOSUG="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
SYNTAX="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

[ ! -d "$AUTOSUG" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUG"
[ ! -d "$SYNTAX" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting "$SYNTAX"

echo "=== Setting Zsh theme to Powerlevel10k ==="
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

echo "=== Copying config files if provided ==="

if [ -f "./zshrc" ]; then
    echo "- Copying ./zshrc → ~/.zshrc"
    cp ./zshrc ~/.zshrc
fi

if [ -f "./p10k.zsh" ]; then
    echo "- Copying ./p10k.zsh → ~/.p10k.zsh"
    cp ./p10k.zsh ~/.p10k.zsh
fi

echo "=== Installing MesloLGS Nerd Fonts (Powerlevel10k recommended) ==="
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

cd "$FONT_DIR"
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

fc-cache -f

echo "=== Done! ==="
echo "➡ Restart your terminal and ensure the font is set to: MesloLGS NF"
echo "➡ If prompt looks wrong, run: p10k configure"
