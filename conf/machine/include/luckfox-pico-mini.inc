# Luckfox Pico Mini (RV1103G)
# Board definition shared by the -sd-card (SD card) and -spi-nand (SPI NAND) machines.
# Do not use directly; select ${MACHINE}-sd-card or ${MACHINE}-spi-nand instead.

require conf/machine/include/rv1103.inc
require conf/machine/include/luckfox-common.inc

# Mini B device tree includes SPI NAND node (exposed as MTD when booting from SD)
KERNEL_DEVICETREE = "rockchip/rv1103g-luckfox-pico-mini-b.dtb"

UBOOT_CONFIG[sdcard] = "luckfox-pico-mini-rv1103g_defconfig"
UBOOT_CONFIG[spi-nand] = "luckfox-pico-mini-rv1103g_defconfig"