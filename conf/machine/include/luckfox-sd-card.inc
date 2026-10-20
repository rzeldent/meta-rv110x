# SD card machine: U-Boot from the sdcard flavour; wic (+bmap) images come
# from rockchip-wic.inc, required by the SoC include.
UBOOT_CONFIG = "sdcard"

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "resize-rootfs"
