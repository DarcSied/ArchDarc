#!/usr/bin/env bash

echo -e "\nSetting up mirrors for optimal download"
iso=$(curl -4 ifconfig.co/country-iso)
timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib terminus-font
setfont ter-v22b
sed -i 's/^#Para/Para/' /etc/pacman.conf
pacman -S --noconfirm reflector rsync
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
echo -e "-----------------------------------------------------------------"
echo -e "  █████╗ ██████╗  ██████╗██╗  ██╗██████╗  █████╗ ██████╗  ██████╗"
echo -e " ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔══██╗██╔══██╗██╔════╝"
echo -e " ███████║██████╔╝██║     ███████║██║  ██║███████║██████╔╝██║     "
echo -e " ██╔══██║██╔══██╗██║     ██╔══██║██║  ██║██╔══██║██╔══██╗██║     "
echo -e " ██║  ██║██║  ██║╚██████╗██║  ██║██████╔╝██║  ██║██║  ██║╚██████╗"
echo -e " ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝"                                                              
echo -e "-----------------------------------------------------------------"
reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
mkdir /mnt


echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm gptfdisk btrfs-progs

echo "---------------------------------------"
echo "---    Select the disk to format    ---"
echo "---------------------------------------"
lsblk
echo "Please enter disk to work on: (example /dev/sda)"
read DISK
echo "THIS WILL FORMAT AND DELETE ALL DATA ON THE DISK"
read -p "Are you sure you want to continue (Y/N):" formatdisk
case $formatdisk in

y|Y|yes|Yes|YES)
echo -e "\nFormatting disk...\n$HR"

# disk prep
sgdisk -Z ${DISK} # zap all on disk
#dd if=/dev/zero of=${DISK} bs=1M count=200 conv=fdatasync status=progress
sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

# create partitions
sgdisk -n 1:0:+1024M ${DISK} # partition 1 (UEFI SYS), default start block, 512MB
sgdisk -n 2:0:0     ${DISK} # partition 2 (Root), default start, remaining

# set partition types
sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}

# label partitions
sgdisk -c 1:"UEFISYS" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}

# make filesystems
echo -e "\nCreating Filesystems...\n$HR"
if [[ ${DISK} =~ "nvme" ]]; then
mkfs.vfat -F32 -n "UEFISYS" "${DISK}p1"
mkfs.btrfs -L "ROOT" "${DISK}p2" -f
mount -t btrfs "${DISK}p2" /mnt
else
mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"
mkfs.btrfs -L "ROOT" "${DISK}2" -f
mount -t btrfs "${DISK}2" /mnt
fi
ls /mnt | xargs btrfs subvolume delete
btrfs subvolume create /mnt/@
umount /mnt
;;
esac

# mount target
mount -t btrfs -o subvol=@ -L ROOT /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -t vfat -L UEFISYS /mnt/boot/

echo -e "\nInstalling Arch on Main Drive"
pacstrap /mnt base base-devel linux linux-firmware vim sudo archlinux-keyring wget libnewt --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf

echo -e "\nBootloader Systemd Installation"
bootctl install --esp-path=/mnt/boot
[ ! -d "/mnt/boot/loader/entries" ] && mkdir -p /mnt/boot/loader/entries
cat <<EOF > /mnt/boot/loader/entries/arch.conf
title Arch Linux  
linux /vmlinuz-linux  
initrd  /initramfs-linux.img  
options root=LABEL=ROOT rw rootflags=subvol=@
EOF
cp -R ~/ArchDarc /mnt/root/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
echo "-------------------------------------"
echo "---    PROCEEDING WITH 1-setup    ---"
echo "-------------------------------------"
