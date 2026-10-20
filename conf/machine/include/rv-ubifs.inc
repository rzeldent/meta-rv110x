# 'RV_SPI_NAND_STORAGE' indicates the user wants to use the
# ubifs configuration from this layer
OVERRIDES .= "${@ ':rv-ubifs' if bb.utils.to_boolean(d.getVar('RV_SPI_NAND_STORAGE'), False) else ''}"

UBOOT_CONFIG:rv-ubifs = "spi-nand"

UBI_VOLNAME = "rootfs"

UBOOT_EXTLINUX_ROOT:rv-ubifs = "ubi.mtd=rootfs root=ubi0:${UBI_VOLNAME}"
UBOOT_EXTLINUX_KERNEL_ARGS:rv-ubifs = "rootfstype=ubifs rootwait rw ${mtdparts}"

IMAGE_FSTYPES:remove:rv-ubifs = "wic${WIC_COMPRESSION_EXTENSION} wic.bmap"

MKUBIFS_ARGS = "-F -m 2048 -e 124KiB -c 1020"
UBINIZE_ARGS = "-m 2048 -p 128KiB -O 2048"
