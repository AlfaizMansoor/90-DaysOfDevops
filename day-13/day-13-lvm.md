# Linux Volume Management (LVM)

# Commands Used
- sudo su                                    :- switch user 
- lsblk                                      :- check the storage block
- pvs                                        :- checks which physical device is connect to LVM
- vgs                                        :- display information about volume groups
- lvs                                        :- display the information about logical volumes
- df -h                                      :- Shows disk usage of mounted filesystems
- pvcreate /dev/nvme1n1                      :- creation of physical volume
- vgcreate devops-vg /dev/sdb                :- creation of volume group using physical volume
- lvcreate -L 10G -n app-data devops-vg      :- creating logical volume from volume group devops-vg
- mkfs.ext4 /dev/devops-vg/app-data          :- to format the /app-data
- mkdir -p /mnt/app-data                     :- to make a directory 
- mount /dev/devops-vg/app-data /mnt/app-data:- mounting volume directory in /mnt/app-data
- df -h /mnt/app-data                        :- checking the disk usage of /mnt/app-data
- lvextend -L +5G /dev/devops-vg/app-data    :- extends logical to 5G

# What I learned
- how to create volume blocks
- how to create physical volume device, volume group, logical volume
- how to mount volumes and extend logical volumes