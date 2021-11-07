#!/usr/bin/env bash

echo -e "\nGRUB EFI Bootloader Install&Check"
if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK}
fi
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\nEnabling Login Display Manager"
if pacman -Qs | grep -E "sddm"; then
    sudo systemctl enable sddm.service
elif pacman -Qs | grep -E "lightdm"; then
    sudo systemctl enable lightdm.service
fi

# Copying configs and applying themes
mkdir $HOME/.config
cp -r $HOME/ArchDarc/dotfiles/* $HOME/.config/
mkdir $HOME/bin
cp -r $HOME/ArchDarc/scripts/* $HOME/bin/
mkdir $HOME/wallpapers/
cp -r $HOME/ArchDarc/wallpapers/* $HOME/wallpapers/

if pacman -Qs | grep -E "bspwm"; then
cp $HOME/ArchDarc/.xinitrc $HOME/
xwallpaper --zoom $HOME/wallpapers/0.jpg
fi

if pacman -Qs | grep -E "plasma-desktop"; then
export PATH=$PATH:$HOME/.local/bin
pip install konsave
konsave -i $HOME/ArchDarc/breeze.knsv
sleep 1
konsave -a breeze
fi

echo -e "\nSetting up SDDM Theme"
if pacman -Qs | grep -E "plasma-desktop"; then
sudo cat <<EOF > /etc/sddm.conf
[Theme]
Current=Breeze
EOF
fi

echo -e "\nEnabling essential services"
systemctl enable cups.service
ntpd -qg
systemctl enable ntpd.service
systemctl disable dhcpcd.service
systemctl stop dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth

# Set keyboard layout to colemak
setxkbmap us -variant colemak

echo -e "\nCleaning up"

# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Replace in the same state
cd $pwd
echo "
##########################################################
###    Done!! Please Eject Install Media and Reboot    ###
##########################################################
"
