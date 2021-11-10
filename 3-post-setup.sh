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
# Cleaning up orphans
sudo pacman -R $(pacman -Qtdq) --noconfirm --needed
# Auto-clean hook for systemd journal
sed -i 's/^#SystemMaxUse=/SystemMaxUse=50M/' /etc/systemd/journald.conf
# Auto-clean hook for pacman cache
sudo cp $HOME/ArchDarc/files/paccache.timer /etc/systemd/system/
sudo systemctl enable paccache.timer

# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

echo "--------------------------------------"
echo "---    PROCEEDING WITH 4-config    ---"
echo "--------------------------------------"
