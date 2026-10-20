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
#   nand-mtd    - SPI NAND exposed as MTD (for Mini B SD card variant with NAND populated)
#
# Example:
#   LUCKFOX_FEATURES = "camera aic8800dc npu vcodec"
#   MACHINE = "luckfox-pico-max-spi-nand"
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
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:append:camera = " \
    kernel-module-sc3336 \
    kernel-module-phy-rockchip-csi2-dphy \
    kernel-module-phy-rockchip-csi2-dphy-hw \
    kernel-module-rockchip-cif-vendor \
"

# ---------------------------------------------------------------------------
# aic8800dc: AIC8800DC WiFi/BT via SDIO
# ---------------------------------------------------------------------------
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:append:aic8800dc = " \
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
# The mainline kernel has no RV1103/RV1106 NPU driver. The only in-tree
# candidate, drivers/accel/rocket, is RK3588-only and gated on ARM64, and the
# vendor driver (drivers/rknpu in the 5.10 buildroot tree) has not been ported
# to this kernel. The feature is therefore accepted but currently pulls in
# nothing, so that existing LUCKFOX_FEATURES lists keep working.
#MACHINE_ESSENTIAL_EXTRA_RDEPENDS:append:npu = " \
#    kernel-module-rockchip-rknpu \
#"

# ---------------------------------------------------------------------------
# vcodec: VPU/VIDEO codec kernel drivers (RGA, VDEC)
# ---------------------------------------------------------------------------
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:append:vcodec = " \
    kernel-module-rockchip-rga \
    kernel-module-rockchip-vdec \
"

# ---------------------------------------------------------------------------
# nand-mtd: SPI NAND exposed as MTD (not boot medium)
# ---------------------------------------------------------------------------
# This is for boards like Mini B SD card variant where NAND is populated
# but the system boots from SD card. The NAND is exposed as raw MTD to Linux.
# No UBOOT_CONFIG change, no UBIFS images.
# The device tree must include the spi_nand node (already in mini-b.dts).