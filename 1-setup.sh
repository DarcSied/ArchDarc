#!/usr/bin/env bash

echo -e "\nSetting up Network"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager

echo -e "\nSetting up mirrors for optimal download"
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector rsync
iso=$(curl -4 ifconfig.co/country-iso)
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have "$nc" cores."
echo -e "\nChanging the makeflags for "$nc" cores."
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [[  $TOTALMEM -gt 8000000 ]]; then
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf
fi

echo -e "\nSetting-up Language and Locale (By default to en_IN)"
sed -i 's/^#en_IN.UTF-8 UTF-8/en_IN.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone Asia/Kolkata
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_IN.UTF-8" LC_TIME="en_IN.UTF-8"
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo LANG=en_IN.UTF-8 > /etc/locale.conf
echo KEYMAP=colemak > /etc/vconsole.conf

# Adding sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# Adding parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

# Enabling multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

# Adding user and giving a hostname
if ! source install.conf; then
	read -p "Please enter username:" username
echo "username=$username" >> ${HOME}/ArchDarc/install.conf
fi
if [ $(whoami) = "root"  ]; then
    useradd -m -G wheel,libvirt -s /bin/bash $username 
	passwd $username
	cp -R /root/ArchDarc /home/$username/
    chown -R $username: /home/$username/ArchDarc
	read -p "Please name your machine:" nameofmachine
	echo $nameofmachine > /etc/hostname
else
	echo "You are already a user proceed further"
fi

# Choose DE or WM route
finished=false  
while [ "$finished" != "true" ]
do
    echo -e "\nChoose between the following [123]"
    echo -e "1) KDE    2) BSPWM    3) Something else\n" 
    read OPT

    if [ "$OPT" = 1 ]; then
	    echo -e "\nInstalling KDE Packages\n"
        finished=true
	    sudo pacman -S plasma-desktop ark audiocd-kio bluedevil breeze breeze-gtk kvantum-qt5 kde-gtk-config kdeplasma-addons layer-shell-qt milou plasma-pa powerdevil sddm sddm-kcm spectacle systemsettings xdg-desktop-portal-kde zeroconf-ioslave --noconfirm --needed
    elif [ "$OPT" = 2 ]; then
   	    echo -e "\nInstalling BSPWM Packages\n"
        finished=true
        sudo pacman -S bspwm sxhkd polybar rofi lxappearence lxpolkit qt5ct dunst betterlockscreen flameshot gufw lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4-power-manager --noconfirm --needed
    elif [ "$OPT" = 3 ]; then
    	echo -e "\nYou can install your choice after the script ends\n"
        finished=true
    else
        echo -e "\nType a valid command"
    fi
done

# Determine processor brand and install appropriate microcode
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

echo "------------------------------------"
echo "---    PROCEEDING WITH 2-user    ---"
echo "------------------------------------"

