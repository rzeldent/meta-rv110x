# Luckfox Pico Plus (RV1106)
# Board definition shared by the -sd-card (SD card) and -spi-nand (SPI NAND) machines.
# Do not use directly; select ${MACHINE}-sd-card or ${MACHINE}-spi-nand instead.

require conf/machine/include/rv1106.inc
require conf/machine/include/luckfox-common.inc

KERNEL_DEVICETREE = "rockchip/rv1106-luckfox-pico-plus.dtb"

UBOOT_CONFIG[sdcard] = "luckfox-pico-plus-rv1106_defconfig"
UBOOT_CONFIG[spi-nand] = "luckfox-pico-plus-rv1106_defconfig"

# Max adds rk-u-boot-env for saveable U-Boot environment
# MACHINE_FEATURES += "rk-u-boot-env"
