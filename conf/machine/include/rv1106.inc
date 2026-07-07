SOC_FAMILY = "rv1106"
RK_KERNEL_FITIMAGE ?= "False"

ROCKCHIP_CLOSED_TPL ?= "1"

require conf/machine/include/soc-family.inc
require conf/machine/include/rockchip-defaults.inc
require conf/machine/include/arm/armv7a/tune-cortexa7.inc
require conf/machine/include/rv-common.inc
require conf/machine/include/rockchip-wic.inc

PREFERRED_PROVIDER_virtual/kernel = "linux-yocto-dev"

SERIAL_CONSOLES = "115200;ttyS2"

KBUILD_DEFCONFIG = "multi_v7_defconfig"

UBOOT_SUFFIX ?= "img"

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "kernel-image"
MACHINE_EXTRA_RRECOMMENDS += "kernel-modules"

ENABLE_STATELESS_VPU_GST ?= "1"
