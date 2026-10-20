# SPI NAND machine: U-Boot from the spi-nand flavour, UBI image (no wic).
UBOOT_CONFIG = "spi-nand"

# Activates the rv-ubifs override; must be set before rv-ubifs.inc is parsed.
RV_SPI_NAND_STORAGE = "1"
require conf/machine/include/rv-ubifs.inc

IMAGE_FSTYPES = "ubi"
