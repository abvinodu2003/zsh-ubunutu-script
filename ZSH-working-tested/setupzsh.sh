#!/bin/bash
set -e

echo "=== Installing Zsh, Git, Curl, Wget ==="
sudo apt update
sudo apt install -y zsh git curl wget

echo "=== Setting Zsh as default shell ==="
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
fi

echo "=== Installing Oh-My-Zsh (without automatic launch) ==="
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "=== Installing Powerlevel10k theme ==="
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

echo "=== Installing plugins: autosuggestions & syntax highlighting ==="
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions" || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGIN_DIR/zsh-syntax-highlighting" || true

echo "=== Writing placeholder for .p10k.zsh ==="
cat > ~/.p10k.zsh <<'EOF'
### P10K CONFIG PLACEHOLDER
EOF

echo "=== Injecting full .p10k.zsh content ==="
sed -i '/### P10K CONFIG PLACEHOLDER/r ./p10k-full.zsh' ~/.p10k.zsh
sed -i '/### P10K CONFIG PLACEHOLDER/d' ~/.p10k.zsh

echo "=== Creating ~/.zshrc with theme and plugins ==="
cat > ~/.zshrc <<'EOF'
# Disable Powerlevel10k wizard
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Instant prompt (optional but recommended)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Load full Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF

echo "=== Installing MesloLGS Nerd Fonts ==="
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"
for f in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
    wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/${f}"
done
fc-cache -f

echo "=== Completed! ==="
echo "⚠ Restart your terminal and set the font to: MesloLGS NF"
echo "⚠ Your prompt will now match your original machine exactly"
