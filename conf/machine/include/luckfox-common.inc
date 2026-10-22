# Common Luckfox machine configuration
#
# This file is included by all Luckfox machine configurations.
# It contains the shared boilerplate that was previously duplicated
# across all 12 machine confs.

require conf/machine/include/luckfox-features.inc

MACHINE_EXTRA_RRECOMMENDS += "kernel-modules"

# Base MACHINE_FEATURES common to all Luckfox boards
MACHINE_FEATURES += "usbhost usbgadget wifi bluetooth"

# Serial consoles: ttyS2 (UART) + ttyGS0 (USB gadget)
SERIAL_CONSOLES = "115200;ttyS2 115200;ttyGS0"

# Kernel
PREFERRED_PROVIDER_virtual/kernel = "linux-yocto-dev"
KBUILD_DEFCONFIG = "multi_v7_defconfig"

# U-Boot: UBOOT_CONFIG and the image types are selected by the -sd-card / -spi-nand
# machine (see luckfox-sd-card.inc and luckfox-spi-nand.inc).
UBOOT_SUFFIX ?= "img"

# VPU/VIDEO codec userspace (not yet packaged as recipes)
ENABLE_STATELESS_VPU_GST ?= "1"

# Capture and bus inspection tools
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "v4l-utils i2c-tools"