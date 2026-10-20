SOC_FAMILY = "rv1106"
RK_KERNEL_FITIMAGE ?= "False"

ROCKCHIP_CLOSED_TPL ?= "1"

require conf/machine/include/soc-family.inc
require conf/machine/include/rockchip-defaults.inc
require conf/machine/include/arm/armv7a/tune-cortexa7.inc
require conf/machine/include/rv-common.inc
require conf/machine/include/rockchip-wic.inc

PREFERRED_PROVIDER_virtual/kernel = "linux-yocto-dev"

SERIAL_CONSOLES = "115200;ttyS2 115200;ttyGS0"

KBUILD_DEFCONFIG = "multi_v7_defconfig"

UBOOT_SUFFIX ?= "img"

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "kernel-image usb-gadget-serial"
MACHINE_EXTRA_RRECOMMENDS += "kernel-modules"

ENABLE_STATELESS_VPU_GST ?= "1"

# Vision userspace libraries: MPP (VPU encode/decode), RGA (2D graphics),
# RKAIQ (ISP 3A), rockit (image processing), RKNNMRT (NPU inference) and
# rkadk (media framework).
# These are not packaged as Yocto recipes in this layer yet (see README),
# so they cannot be listed as recommendations without breaking the build.
#MACHINE_EXTRA_RRECOMMENDS += "libmpp librga librkaiq librockit librknnmrt rkadk"

# Capture and bus inspection tools
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "v4l-utils i2c-tools"
