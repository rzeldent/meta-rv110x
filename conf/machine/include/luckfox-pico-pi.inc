# Luckfox Pico Pi (RV1106)
# Board definition shared by the -sd-card (SD card) and -spi-nand (SPI NAND) machines.
# Do not use directly; select ${MACHINE}-sd-card or ${MACHINE}-spi-nand instead.

require conf/machine/include/rv1106.inc
require conf/machine/include/luckfox-common.inc

KERNEL_DEVICETREE = "rockchip/rv1106g-luckfox-pico-pi.dtb"

UBOOT_CONFIG[sdcard] = "luckfox-pico-rv1106_defconfig"
UBOOT_CONFIG[spi-nand] = "luckfox-pico-rv1106_defconfig"