#!/usr/bin/env bash

# Copying configs and applying themes
mkdir $HOME/.config/
mkdir $HOME/bin/
cp -r $HOME/ArchDarc/files/.bashrc $HOME/

if pacman -Qs | grep -E "bspwm"; then
cp -r $HOME/ArchDarc/scripts/* $HOME/bin/
mkdir $HOME/wallpapers/
cp -r $HOME/ArchDarc/wallpapers/* $HOME/wallpapers/
cp $HOME/ArchDarc/files/.xinitrc $HOME/
xwallpaper --zoom $HOME/wallpapers/0.jpg
cp -r $HOME/ArchDarc/dotfiles/* $HOME/.config/
fi

if pacman -Qs | grep -E "plasma-desktop"; then
export PATH=$PATH:$HOME/.local/bin
pip install konsave
konsave -i $HOME/ArchDarc/breeze.knsv
sleep 2
export PATH=$PATH:$HOME/.local/bin
konsave -a breeze
cp -r $HOME/ArchDarc/dotfiles/alacritty $HOME/.config/
fi

echo -e "\nSetting up SDDM Theme"
if pacman -Qs | grep -E "plasma-desktop"; then
sudo cat <<EOF > /etc/sddm.conf
[Theme]
Current=Breeze
EOF
fi

# Replace in the same state
cd $pwd
echo "
##########################################################
###    Done!! Please Eject Install Media and Reboot    ###
##########################################################
"
