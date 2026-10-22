# Luckfox feature flags
#
# LUCKFOX_FEATURES is a space-separated list of optional features to enable.
# Each feature adds an override to MACHINEOVERRIDES so that feature-specific
# configuration can be applied via :feature suffixes (e.g. IMAGE_FSTYPES:nand).
#
# Supported features:
#   camera      - MIPI CSI camera stack (SC3336 sensor, CIF, ISP1)
#   rtl8723bs   - Realtek RTL8723BS WiFi via SDIO (rtw88 out-of-tree driver)
#   npu         - Rockchip NPU kernel driver (rknpu)
#   vcodec      - VPU/VIDEO codec kernel drivers (RGA, VDEC)
#   nand-mtd    - SPI NAND exposed as MTD (for Mini B SD card variant with NAND populated)
#
# Example:
#   LUCKFOX_FEATURES = "camera rtl8723bs npu vcodec"
#   MACHINE = "luckfox-pico-max-spi-nand"
LUCKFOX_FEATURES ?= "camera npu vcodec"

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
    kernel-module-rockchip-isp1 \
"

# ---------------------------------------------------------------------------
# rtl8723bs: Realtek RTL8723BS WiFi via SDIO (out-of-tree rtw88 driver).
# ---------------------------------------------------------------------------
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:append:rtl8723bs = " \
    kernel-module-rtw-core \
    kernel-module-rtw-8723x \
    kernel-module-rtw-8723b \
    kernel-module-rtw-sdio \
    kernel-module-rtw-8723bs \
    rtl8723bs-firmware \
    rtl8723bs-init \
    wpa-supplicant \
"

# ---------------------------------------------------------------------------
# npu: Rockchip NPU kernel driver
# ---------------------------------------------------------------------------
# Used on both RV1103 and RV1106: the vendor kernel binds both to rockchip,rv1106-rknpu.
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:append:npu = " \
    kernel-module-rknpu \
    librknnmrt \
"

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