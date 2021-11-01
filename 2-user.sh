#!/usr/bin/env bash

echo -e "\nInstalling System Packages\n"
PKGS=(
'plasma-desktop'
'alacritty'
'alsa-plugins'
'alsa-utils'
'ark'
'audiocd-kio' 
'autoconf'
'automake'
'base'
'base-devel'
'bind'
'binutils'
'bison'
'bluedevil'
'bluez'
'bluez-libs'
'breeze'
'breeze-gtk'
'bridge-utils'
'btrfs-progs'
'celluloid' # video players
'cmatrix'
'code' # Visual Studio code
'cronie'
'cups'
'dialog'
'dosfstools'
'efibootmgr' # EFI boot
'egl-wayland'
'exfat-utils'
'flex'
'fuse2'
'fuse3'
'fuseiso'
'gamemode'
'gcc'
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
'kde-gtk-config'
'layer-shell-qt'
'libnewt'
'libtool'
'linux'
'linux-firmware'
'linux-headers'
'lsof'
'lutris'
'lzop'
'm4'
'make'
'man-db'
'milou'
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
'python-pip'
'qbittorrent'
'qemu'
'rsync'
'sddm'
'sddm-kcm'
'snapper'
'spectacle'
'steam'
'sudo'
'swtpm'
'sxiv'
'systemsettings'
'terminus-font'
'thunar'
'traceroute'
'ufw'
'unrar'
'unzip'
'usbutils'
'virt-manager'
'virt-viewer'
'vivaldi'
'wget'
'which'
'wine-gecko'
'wine-mono'
'winetricks'
'xdg-desktop-portal-kde'
'xdg-users-dirs'
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
'awesome-terminal-fonts'
'capitaine-cursors'
'dxvk-bin' # DXVK DirectX to Vulcan
'github-desktop-bin' # Github Desktop sync
'mangohud' # Gaming FPS Counter
'mangohud-common'
'nerd-fonts-roboto-mono'
'noto-fonts-emoji'
'papirus-icon-theme'
'plasma-pa'
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
konsave -i $HOME/ArchDarc/breeze.knsv
sleep 1
konsave -a breeze

echo "------------------------------------------"
echo "---    PROCEEDING WITH 3-post-setup    ---"
echo "------------------------------------------"
exit
