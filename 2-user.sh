#!/usr/bin/env bash

echo -e "\nInstalling AUR Packages\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "Cloning: Paru"
cd ~
git clone "https://aur.archlinux.org/paru.git"
cd ${HOME}/paru
makepkg -si --noconfirm
cd ~
touch "$HOME/.cache/zshhistory"
git clone "https://github.com/ChrisTitusTech/zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
ln -s "$HOME/zsh/.zshrc" $HOME/.zshrc

PKGS=(
'autojump'
'awesome-terminal-fonts'
'dxvk-bin' # DXVK DirectX to Vulcan
'github-desktop-bin' # Github Desktop sync
'mangohud' # Gaming FPS Counter
'mangohud-common'
'nerd-fonts-roboto-mono'
'noto-fonts-emoji'
'papirus-icon-theme'
'ocs-url' # install packages from websites
'snapper-gui-git'
'ttf-droid'
'ttf-hack'
'ttf-roboto'
'snap-pac'
'spotify'
)

for PKG in "${PKGS[@]}"; do
    paru -S --noconfirm $PKG
done

export PATH=$PATH:~/.local/bin
cp -r $HOME/ArchDarc/dotfiles/* $HOME/.config/
pip install konsave
# konsave -i $HOME/ArchDarc/kde.knsv
# sleep 1
# konsave -a kde

echo "------------------------------------------"
echo "---    PROCEEDING WITH 3-post-setup    ---"
echo "------------------------------------------"
exit
