echo "
###########################################################################
###    Shutting down in 5 sec. Please Eject Install Media and Reboot    ###
###########################################################################
"
sleep 5
exit
umount -R /mnt
shutdown now