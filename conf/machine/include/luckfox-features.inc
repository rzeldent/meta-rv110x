# Luckfox feature flags
#
# LUCKFOX_FEATURES is a space-separated list of optional features to enable.
# Each feature adds an override to MACHINEOVERRIDES so that feature-specific
# configuration can be applied via :feature suffixes (e.g. IMAGE_FSTYPES:nand).
#
# Supported features:
#   camera      - MIPI CSI camera stack (SC3336 sensor, CIF, ISP1)
#   aic8800dc   - AIC8800DC WiFi/BT via SDIO (kernel modules, firmware, init, wpa-supplicant, bluez5)
#   npu         - Rockchip NPU kernel driver (rknpu)
#   vcodec      - VPU/VIDEO codec kernel drivers (RGA, VDEC)
#   nand        - SPI NAND boot (UBOOT_CONFIG=spi-nand, UBIFS images, rv-ubifs.inc)
#   nand-mtd    - SPI NAND exposed as MTD (for Mini B SD card variant with NAND populated)
#
# Example:
#   LUCKFOX_FEATURES = "camera aic8800dc npu vcodec nand"
#   MACHINE = "luckfox-pico-max"
#
# The default enables everything that was previously mandatory.
LUCKFOX_FEATURES ?= "camera aic8800dc npu vcodec"

# Add features to MACHINE_FEATURES so they can be tested with bb.utils.contains
MACHINE_FEATURES += "${LUCKFOX_FEATURES}"

# Translate each feature into a MACHINEOVERRIDES entry
MACHINEOVERRIDES .= "${@''.join(':' + f for f in d.getVar('LUCKFOX_FEATURES').split())}"

# ---------------------------------------------------------------------------
# camera: MIPI CSI camera stack
# ---------------------------------------------------------------------------
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:camera += " \
    kernel-module-sc3336 \
    kernel-module-phy-rockchip-csi2-dphy \
    kernel-module-phy-rockchip-csi2-dphy-hw \
    kernel-module-rockchip-cif-vendor \
"

# ---------------------------------------------------------------------------
# aic8800dc: AIC8800DC WiFi/BT via SDIO
# ---------------------------------------------------------------------------
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:aic8800dc += " \
    kernel-module-aic8800-bsp \
    kernel-module-aic8800-fdrv \
    kernel-module-aic8800-btlpm \
    aic8800dc-firmware \
    aic8800dc-init \
    wpa-supplicant \
    bluez5 \
"

# ---------------------------------------------------------------------------
# npu: Rockchip NPU kernel driver
# ---------------------------------------------------------------------------
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:npu += " \
    kernel-module-rockchip-rknpu \
"

# ---------------------------------------------------------------------------
# vcodec: VPU/VIDEO codec kernel drivers (RGA, VDEC)
# ---------------------------------------------------------------------------
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:vcodec += " \
    kernel-module-rockchip-rga \
    kernel-module-rockchip-vdec \
"

# ---------------------------------------------------------------------------
# nand: SPI NAND boot
# ---------------------------------------------------------------------------
# Reuse the existing rv-ubifs.inc mechanism via RV_SPI_NAND_STORAGE
RV_SPI_NAND_STORAGE:nand = "1"
require conf/machine/include/rv-ubifs.inc

# ---------------------------------------------------------------------------
# nand-mtd: SPI NAND exposed as MTD (not boot medium)
# ---------------------------------------------------------------------------
# This is for boards like Mini B SD card variant where NAND is populated
# but the system boots from SD card. The NAND is exposed as raw MTD to Linux.
# No UBOOT_CONFIG change, no UBIFS images.
# The device tree must include the spi_nand node (already in mini-b.dts).