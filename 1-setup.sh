#!/usr/bin/env bash

echo -e "\nNetwork Setup"
pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager

echo -e "\nSetting up mirrors for optimal download"
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector rsync
iso=$(curl -4 ifconfig.co/country-iso)
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have "$nc" cores."
echo "Changing the makeflags for "$nc" cores."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf

echo -e "\nSetting-up Language and Locale (By default to en_IN)"
sed -i 's/^#en_IN.UTF-8 UTF-8/en_IN.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone Asia/Kolkata
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_IN.UTF-8" LC_COLLATE="" LC_TIME="en_IN.UTF-8"

# Set keymaps
localectl --no-ask-password set-keymap colemak

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

echo -e "\nInstalling Base System\n"
PKGS=(
'alacritty'
'alsa-plugins'
'alsa-utils'
'ark'
'audiocd-kio' 
'base'
'base-devel'
'bind'
'bluedevil'
'bluez'
'bluez-libs'
'breeze'
'breeze-gtk'
'bridge-utils'
'btrfs-progs'
'celluloid' # video players
'clamav'
'clamtk'
'cmatrix'
'code' # Visual Studio code
'cronie'
'cups'
'dhcpcd'
'dialog'
'dmidecode'
'dnsmasq'
'dosfstools'
'drkonqi'
'edk2-ovmf'
'efibootmgr' # EFI boot
'exfat-utils'
'fuse2'
'fuse3'
'fuseiso'
'gamemode'
'git'
'gparted' # partition management
'gptfdisk'
'grub'
'grub-customizer'
'gst-libav'
'gst-plugins-good'
'gst-plugins-ugly'
'haveged'
'htop'
'iptables-nft'
'jdk-openjdk' # Java 17
'kvantum-qt5'
'kcalc'
'kcharselect'
'kcron'
'kde-gtk-config'
'kdecoration'
'kdenetwork-filesharing'
'kdeplasma-addons'
'kdesdk-thumbnailers'
'kdialog'
'keychain'
'kgamma5'
'kgpg'
'khotkeys'
'kinfocenter'
'kmix'
'krunner'
'kscreen'
'kscreenlocker'
'ksshaskpass'
'ksystemlog'
'kvantum-qt5'
'kwallet-pam'
'kwalletmanager'
'libguestfs'
'libksysguard'
'linux'
'linux-firmware'
'linux-headers'
'lsof'
'lutris'
'lzop'
'man-db'
'milou'
'neovim'
'neofetch'
'ntfs-3g'
'openbsd-netcat'
'openssh'
'os-prober'
'pacman-contrib'
'packagekit-qt5'
'picom'
'plasma-browser-integration'
'plasma-desktop'
'plasma-disks'
'plasma-firewall'
'plasma-nm'
'plasma-pa'
'plasma-sdk'
'plasma-systemmonitor'
'plasma-vault'
'plasma-workspace'
'plasma-workspace-wallpapers'
'powerdevil'
'powerline-fonts'
'print-manager'
'pulseaudio'
'pulseaudio-alsa'
'pulseaudio-bluetooth'
'python-pip'
'qbittorrent'
'qemu'
'rsync'
'sddm'
'sddm-kcm'
'snapper'
'spectacle'
'steam'
'swtpm'
'sxiv'
'terminus-font'
'thunar'
'traceroute'
'ufw'
'unrar'
'usbutils'
'vde2'
'virt-manager'
'virt-viewer'
'vivaldi'
'wget'
'wine-gecko'
'wine-mono'
'winetricks'
'xdg-desktop-portal-kde'
'xorg'
'xorg-xinit'
'youtube-dl'
'zeroconf-ioslave'
'zathura'
'zathura-pdf-mupdf'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

#
# determine processor type and install microcode
# 
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

if ! source install.conf; then
	read -p "Please enter username:" username
echo "username=$username" >> ${HOME}/ArchDarc/install.conf
fi
if [ $(whoami) = "root"  ];
then
    useradd -m -G wheel,libvirt -s /bin/bash $username 
	passwd $username
	cp -R /root/ArchDarc /home/$username/
    chown -R $username: /home/$username/ArchDarc
else
	echo "You are already a user proceed further"
fi

echo "------------------------------------"
echo "---    PROCEEDING WITH 2-user    ---"
echo "------------------------------------"

