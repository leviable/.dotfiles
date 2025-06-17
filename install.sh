#!/bin/bash

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
STOWED="$SCRIPT_DIR/stowed"
INSTALL_LOG="$SCRIPT_DIR/install.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

padding=14

function darwin { [ "$(uname -s)" = "Darwin" ]; }
function linux { [ "$(uname -s)" = "Linux" ]; }

function checking() { echo -en "\r\033[K$(printf %-${padding}s """$program"""): ${YELLOW}Checking${NC}"; }
function installing() { echo -en "\r\033[K$(printf %-${padding}s """$program"""): ${YELLOW}Installing${NC}"; }
function installed() { echo -e "\r\033[K$(printf %-${padding}s """$program"""): ${GREEN}Installed${NC}"; }
function updating() { echo -en "\r\033[K$(printf %-${padding}s """$program"""): ${YELLOW}Updating${NC}"; }
function updated() { echo -e "\r\033[K$(printf %-${padding}s """$program"""): ${GREEN}Updated${NC}"; }
function failed() { echo -e "\r\033[K$(printf %-${padding}s """$program"""): ${RED}Failed${NC} - See $INSTALL_LOG for more details"; }

function do-install() {
  if command -v "$1" &>/dev/null; then
    installed
  else
    installing
    if darwin; then
      {
        brew install "$1" >>"$INSTALL_LOG" 2>&1 &&
          installed
      } || {
        failed
      }
    else
      {
        # shellcheck disable=SC2024
        DEBIAN_FRONTEND=noninteractiv sudo apt install -y "$1" >>"$INSTALL_LOG" 2>&1 &&
          installed
      } || {
        failed
      }
    fi
  fi
}

function backup() {
  base="${1%/*}"
  file="${1##*/}"
  backupdir="$base/dotfiles-backup"
  mkdir -p "$backupdir"
  cp "$1" "$backupdir"/"$file"-backup-"$(date +%s)" && rm "$1"
}

# ###############################
#
# Enable Sudo
#
# ###############################

echo "Grand sudo access"
sudo ls &>/dev/null

# ###############################
#
# .config
#
# ###############################

mkdir -p "$HOME/.config"

# ###############################
#
# macOs Typing Speed
#
# ###############################

program="typing speed"
if darwin; then
  {
    updating
    defaults write NSGlobalDomain InitialKeyRepeat -int 20
    defaults write NSGlobalDomain KeyRepeat -int 2
    updated
  } || {
    failed
  }
fi

# ###############################
#
# Homebrew
#
# ###############################

program="homebrew"
homebrew_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
if darwin; then
  checking
  if command -v brew &>/dev/null; then
    installed
  else
    installing
    {
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL "$homebrew_url")" >>"$INSTALL_LOG" 2>&1
      (
        echo
        # shellcheck disable=SC2016
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
      ) >>/Users/levi/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
      installed
    } || {
      failed
    }
  fi
fi

# ###############################
#
# Apt update
#
# ###############################

program="apt"
if linux; then
  updating
  {
    # shellcheck disable=SC2024
    sudo apt update >>"$INSTALL_LOG" 2>&1
    updated
  } || {
    failed
  }
fi

# ###############################
#
# Curl
#
# ###############################

program="curl" do-install curl

# ###############################
#
# gnu make
#
# ###############################

program="make" do-install make

# ###############################
#
# GNU Stow
#
# ###############################

program="gnu stow" do-install stow

# ###############################
#
# Ack
#
# ###############################

program="ack" do-install ack
[[ ! -f "$HOME/.ackrc" ]] || backup "$HOME/.ackrc"
stow -d "$STOWED" -t "$HOME" ack

# ###############################
#
# ripgrep
#
# ###############################

program="ripgrep" do-install ripgrep

# ###############################
#
# luarocks
#
# ###############################

program="luarocks" do-install luarocks

# ###############################
#
# fd-find
#
# ###############################

if darwin; then
  program="fd-find" do-install fd
else
  program="fd-find" do-install fd-find
fi

# ###############################
#
# btop
#
# ###############################

program="btop" do-install btop

# ###############################
#
# Htop
#
# ###############################

program="htop" do-install htop

# ###############################
#
# Eza
#
# ###############################

# This will work with Ubuntu 20.10+
program="eza" do-install eza

# ###############################
#
# fzf
#
# ###############################

program="fzf" do-install fzf

# ###############################
#
# Bat
#
# ###############################

program="bat" do-install bat
# [[ ! "$(uname -s)" = "Linux" ]] || alias

# ###############################
#
# fd
#
# ###############################

program="fd" do-install fd

# ###############################
#
# sd
#
# ###############################

program="sd" do-install sd

# ###############################
#
# hexyl
#
# ###############################

program="hexyl" do-install hexyl

# ###############################
#
# hyperfine
#
# ###############################

program="hyperfine" do-install hyperfine

# ###############################
#
# watchexec
#
# ###############################

program="watchexec" do-install watchexec

# ###############################
#
# dust
#
# ###############################

program="dust" do-install dust

# ###############################
#
# zoxide
#
# ###############################

program="zoxide" do-install zoxide

# ###############################
#
# deb-get
# http://github.com/wimpysanalworld/deb-get
#
# ###############################

program="deb-get" do-install deb-get

# ###############################
#
# lazygit
#
# ###############################

program="lazygit" do-install lazygit

# ###############################
#
# Git
#
# ###############################

program="git" do-install git
[[ ! -f "$HOME/.gitconfig" ]] || backup "$HOME/.gitconfig"
[[ ! -f "$HOME/.gitignore_global" ]] || backup "$HOME/.gitignore_global"
stow -d "$STOWED" -t "$HOME" git

# ###############################
#
# Git GUI
#
# ###############################

program="git gui" do-install git-gui

# ###############################
#
# Git Delta
#
# ###############################

program="git delta" do-install git-delta

# ###############################
#
# entr
#
# ###############################

program="entr" do-install entr

# ###############################
#
# Zsh
#
# ###############################

program="zsh" do-install zsh

# ###############################
#
# Oh My Zsh
#
# ###############################

program="oh my zsh"
omz_url="https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
checking
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  installing
  {
    yes | sh -c "$(curl -fsSL "$omz_url")" >>"$INSTALL_LOG" 2>&1
    installed
  } || { failed; }
else
  installed
fi

# For ubuntu, set default shell to zsh
[[ ! "$(uname -s)" = "Linux" ]] || chsh -s "$(which zsh)"

[[ ! -f "$HOME/.zshrc" ]] || backup "$HOME/.zshrc"
stow -d "$STOWED" -t "$HOME" zshrc

# ###############################
#
# zshrc-tokens
#
# ###############################
#
# touch the tokens file to make sure it exists
touch ~/.zshrc-tokens

# ###############################
#
# Python
#
# ###############################

program="python" do-install python3

if darwin; then
  pip3 install neovim --break-system-packages >>"$INSTALL_LOG" 2>&1
else
  # shellcheck disable=SC2024
  DEBIAN_FRONTEND=noninteractiv sudo apt install -y pip >>"$INSTALL_LOG" 2>&1
  pip install neovim --break-system-packages >>"$INSTALL_LOG" 2>&1
fi

# ###############################
#
# npm
#
# ###############################

program="npm" do-install npm

# ###############################
#
# Go
#
# ###############################

program="go" do-install golang

# ###############################
#
# richgo
#
# ###############################

program="richgo"
checking
if command -v richgo &>/dev/null; then
  installed
else
  installing
  if true; then
    {
      go install github.com/kyoh86/richgo@latest >>"$INSTALL_LOG" 2>&1
      installed
    } || { failed; }
  fi
fi

# ###############################
#
# RustUp
#
# ###############################

program="rustup"
checking
if command -v rustup &>/dev/null; then
  installed
else
  installing
  {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh /dev/stdin -y >>"$INSTALL_LOG" 2>&1
    installed
  } || { failed; }
fi

# ###############################
#
# VIM
#
# ###############################

# Update the system VIM.
# Even though we plan to use nvim, this is needed
#   for vim-go to work correctly
program="vim" do-install vim
[[ ! -f "$HOME/.vimrc" ]] || backup "$HOME/.vimrc"

# ###############################
#
# Neovim
#
# ###############################

if darwin; then
  program="neovim" do-install neovim
else
  # Need nvim > 10.0 - Easiest way to get it is snap
  checking
  if command -v nvim &>/dev/null; then
    installed
  else
    installing
    {
      # shellcheck disable=SC2024
      sudo snap install --beta nvim --classic >>"$INSTALL_LOG" 2>&1
      installed
    } || {
      failed
    }
  fi
fi

[[ ! -f "$HOME/.config/nvim/init.vim" ]] || backup "$HOME/.config/nvim/init.vim"
mkdir -p "$HOME/.config/nvim"
stow -d "$STOWED" -t "$HOME/.config/nvim" neovim

# ###############################
#
# Warp
#
# ###############################

if darwin; then
  checking
  # warp doesn't have a command line launcher, so need to get creative
  if brew list warp &>/dev/null; then
    installed
  else
    installing
    {
      program="warp" install warp
      installed
    } || {
      failed
    }
  fi
else
  checking
  if apt show warp-terminal &>/dev/null; then
    installed
  else
    installing
    {
      (
        sudo apt-get install wget gpg
        wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor >warpdotdev.gpg
        sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
        sudo sh -c 'echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
        rm warpdotdev.gpg
        sudo apt update
      ) >>"$INSTALL_LOG" 2>&1
      program="warp" do-install warp-terminal
      installed
    } || {
      failed
    }
  fi
fi

# ###############################
#
# Starship
#
# ###############################

program="starship"
checking
if command -v starship &>/dev/null; then
  installed
else
  installing
  {
    mkdir -p "$HOME/.local/bin"
    curl -sS https://starship.rs/install.sh | sh /dev/stdin -y -b "$HOME/.local/bin" >>"$INSTALL_LOG" 2>&1
    installed
  } || { failed; }
fi

# ###############################
#
# Nerd Fonts
#
# ###############################

program="nerd fonts"
nerd_font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz"
if darwin; then
  font_dir="$HOME/Library/Fonts"
  tar_args="-xz"
else
  font_dir="$HOME/.local/share/fonts"
  tar_args="xJ"
  mkdir -p "$font_dir"
fi

if ls "$font_dir/FiraCode*" &>/dev/null; then
  installed
else
  installing
  {
    curl -s -L "$nerd_font_url" | tar "$tar_args" -C "$font_dir"
    installed
  } || {
    failed
  }
fi
