#!/bin/bash

    bash 0-preinstall.sh
    arch-chroot /mnt /root/ArchDarc/1-setup.sh
    source /mnt/root/ArchDarc/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/ArchDarc/2-user.sh
    arch-chroot /mnt /root/ArchDarc/3-post-setup.sh
    arch-chroot /mnt /root/ArchDarc/4-config.sh