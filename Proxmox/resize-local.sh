# Run these on the local proxmox server after removing the `local-lvm` storage to put all the data on the `local` storage
lvremove /dev/pve/data
lvresize -l +100%FREE /dev/pve/root
resize2fs /dev/mapper/pve-root