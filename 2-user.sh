#!/usr/bin/env bash

echo -e "\nInstalling KDE Packages\n"
PAKGS=(
'plasma-desktop'
'ark'
'audiocd-kio' 
'bluedevil'
'breeze'
'breeze-gtk'
'kvantum-qt5'
'kde-gtk-config'
'layer-shell-qt'
'milou'
'plasma-pa'
'sddm'
'sddm-kcm'
'spectacle'
'systemsettings'
'xdg-desktop-portal-kde'
'zeroconf-ioslave'
)

for PAKG in "${PAKGS[@]}"; do
    echo "INSTALLING: ${PAKG}"
    sudo pacman -S "$PAKG" --noconfirm --needed
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

echo -e "\nInstalling rest of the packages\n"
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
'ocs-url' # install packages from websites
'sublime-text-4'
'snapper-gui-git'
'ttf-droid'
'ttf-hack'
'ttf-roboto'
'snap-pac'
'spotify'
'alacritty'
'alsa-plugins'
'alsa-utils'
'autoconf'
'automake'
'binutils'
'bind'
'bison'
'bluez'
'bluez-libs'
'bridge-utils'
'celluloid' # video players
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
'gufw'
'haveged'
'htop'
'iptables-nft'
'jdk-openjdk' # Java 17
'libnewt'
'libtool'
'lsof'
'lutris'
'lzop'
'm4'
'man-db'
'neovim'
'neofetch'
'networkmanager'
'ntfs-3g'
'openbsd-netcat'
'openssh'
'os-prober'
'pacman-contrib'
'p7zip'
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
'snapper'
'steam'
'swtpm'
'sxiv'
'terminus-font'
'thunar'
'traceroute'
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
'youtube-dl'
'zathura'
'zathura-pdf-mupdf'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
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
