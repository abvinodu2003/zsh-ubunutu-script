#!/bin/bash

set -e

echo "=== Installing Zsh ==="
sudo apt update
sudo apt install -y zsh git curl wget

echo "=== Setting Zsh as default shell ==="
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

echo "=== Installing extra plugins: autosuggestions + syntax highlighting ==="
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# Autosuggestions plugin
if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"
fi

# Syntax highlighting plugin
if [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGIN_DIR/zsh-syntax-highlighting"
fi

echo "=== Creating ~/.zshrc with required plugins and theme ==="

if [ -f "./zshrc" ]; then
    echo "Copying your custom zshrc → ~/.zshrc"
    cp ./zshrc ~/.zshrc

    echo "Updating plugin list to include autosuggestions + syntax highlighting"
    sed -i 's/^plugins=(.*)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
else
    echo "Writing new ~/.zshrc"
    cat > ~/.zshrc <<'EOF'
# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enhanced plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
fi

echo "=== Installing MesloLGS Nerd Fonts for Powerlevel10k ==="
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

cd "$FONT_DIR"
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

fc-cache -f

echo "=== Copying p10k.zsh if provided ==="
if [ -f "./p10k.zsh" ]; then
    cp ./p10k.zsh ~/.p10k.zsh
fi

echo "=== Completed! ==="
echo "➡ Restart your terminal"
echo "➡ Set the terminal font to: MesloLGS NF"
echo "➡ If prompt looks incorrect, run: p10k configure"
