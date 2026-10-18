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

# MIPI CSI camera stack: the SC3336 sensor, CSI2 DPHY, MIPI CSI2 receiver and
# the CIF capture device. Every board describes the camera in its device tree,
# so a module plugged into the MIPI connector works out of the box.
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "kernel-module-sc3336"
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "kernel-module-phy-rockchip-csi2-dphy"
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "kernel-module-phy-rockchip-csi2-dphy-hw"
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "kernel-module-rockchip-cif-vendor"
# Capture and bus inspection tools. packagegroup-core-boot only honours
# MACHINE_ESSENTIAL_EXTRA_RDEPENDS, so list them there.
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "v4l-utils i2c-tools"
