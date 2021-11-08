#!/usr/bin/env bash

echo -e "\nInstalling AUR Packages\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo LANG=en_IN.UTF-8 > /etc/locale.conf
echo KEYMAP=colemak > /etc/vconsole.conf

echo "CLONING: Paru"
mkdir ~/Packages
cd ~/Packages
git clone "https://aur.archlinux.org/paru.git"
cd ${HOME}/Packages/paru
makepkg -si --noconfirm
cd ~/Packages
touch "$HOME/.cache/zshhistory"
git clone "https://github.com/ChrisTitusTech/zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
ln -s "$HOME/Packages/zsh/.zshrc" $HOME/.zshrc

echo -e "\nInstalling rest of the packages\n"
PKGS=(
'alacritty'
'alsa-plugins'
'alsa-utils'
'autoconf'
'automake'
'bash-completion'
'bind'
'binutils'
'bison'
'bluez'
'bluez-libs'
'btrfs-progs'
'bridge-utils'
'celluloid' # video players
'cronie'
'cups'
'deluge'
'dialog'
'dosfstools'
'dtc'
'efibootmgr' # EFI boot
'egl-wayland'
'exfat-utils'
'extra-cmake-modules'
'filelight'
'flex'
'fuse2'
'fuse3'
'fuseiso'
'gamemode'
'gcc'
'gparted' # partition management
'gptfdisk'
'grub-customizer'
'gst-libav'
'gst-plugins-good'
'gst-plugins-ugly'
'haveged'
'htop'
'iptables-nft'
'jdk-openjdk' # Java 17
'libtool'
'libdvdcss'
'lsof'
'lutris'
'lzop'
'm4'
'neovim'
'neofetch'
'networkmanager'
'ntfs-3g'
'openbsd-netcat'
'openssh'
'os-prober'
'p7zip'
'pacman-contrib'
'patch'
'picom'
'pkgconf'
'powerline-fonts'
'print-manager'
'pulseaudio'
'pulseaudio-alsa'
'pulseaudio-bluetooth'
'pulsemixer'
'python-notify2'
'python-psutil'
'python-pyqt5'
'python-pip'
'qemu'
'snapper'
'steam'
'swtpm'
'sxiv'
'terminus-font'
'thunar'
'tldr'
'traceroute'
'ufw'
'unrar'
'unzip'
'unclutter'
'usbutils'
'virt-manager'
'virt-viewer'
'vivaldi'
'wget'
'which'
'wine-gecko'
'wine-mono'
'winetricks'
'xdg-user-dirs'
'youtube-dl'
'zathura'
'zathura-pdf-mupdf'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
'awesome-terminal-fonts'
'capitaine-cursors'
'dxvk-bin' # DXVK DirectX to Vulcan
'github-desktop-bin' # Github Desktop sync
'mangohud' # Gaming FPS Counter
'mangohud-common'
'nerd-fonts-roboto-mono'
'noto-fonts-emoji'
'papirus-icon-theme'
'ocs-url' # install packages from websites
'sublime-text-4'
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

echo "------------------------------------------"
echo "---    PROCEEDING WITH 3-post-setup    ---"
echo "------------------------------------------"
exit
