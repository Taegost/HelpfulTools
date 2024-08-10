# Mount /etc/pve in recovery mode
Without doing this, we won't be able to modify the VM configs in /etc/pve/qemu-server
`pmxcfs -d -l`

# Update grub for IOMMU passthrough
1. Run `nano /etc/default/grub`
2. Add the following to the *GRUB_CMDLINE_LINUX_DEFAULT* line then save the file:
    - AMD: `amd_iommu=on initcall_blacklist=sysfb_init`
    - Intel: `intel_iommu=on initcall_blacklist=sysfb_init`
3. Run `update-grub`
4. Run `/etc/modules`
5. Add the following to the end of the file:
```
# Modules required for PCI passthrough
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```
6. Run: `update-initramfs -u -k all`