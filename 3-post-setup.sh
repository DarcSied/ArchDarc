#!/usr/bin/env bash

echo -e "\nEnabling Login Display Manager"
if pacman -Qs | grep -E "sddm"; then
    sudo systemctl enable sddm.service
elif pacman -Qs | grep -E "lightdm"; then
    sudo systemctl enable lightdm.service
fi

echo -e "\nSetting up SDDM Theme"
if pacman -Qs | grep -E "plasma-desktop"; then
sudo cat <<EOF > /etc/sddm.conf
[Theme]
Current=Breeze
EOF
fi

echo -e "\nEnabling the cups service daemon so we can print"
systemctl enable cups.service
sudo ntpd -qg
sudo systemctl enable ntpd.service
sudo systemctl disable dhcpcd.service
sudo systemctl stop dhcpcd.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth

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
