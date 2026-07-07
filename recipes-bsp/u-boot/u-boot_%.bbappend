FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend := "${RV110X_DTS}:"

SRC_URI += " \
    file://0001-rockchip-mkimage-add-support-for-rv1106.patch \
    file://0002-ram-rockchip-add-basic-support-for-rv1106.patch \
    file://0003-dt-bindings-clock-rockchip-add-rv1106-clock-and-reset-unit.patch \
    file://0004-clk-rockchip-add-support-for-rv1106.patch \
    file://0005-pinctrl-rockchip-add-support-for-rv1106.patch \
    file://0006-arch-arm-rockchip-add-initial-support-for-rv1106.patch \
    file://0007-board-rockchip-add-rv1106-evb.patch \
    file://0008-add-spl-mtd-load-support.patch \
    file://rv1103g-luckfox-pico-mini.dts;subdir=${P}/arch/arm/dts/ \
    file://rv1103g.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106-pinctrl.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1103g-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1103g-luckfox-pico-mini-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://luckfox-pico-mini-a-rv1103g_defconfig;subdir=${P}/configs/ \
    file://luckfox-pico-mini-b-rv1103g_defconfig;subdir=${P}/configs/ \
"

SRC_URI:append:rv-ubifs = " \
    file://0009-add-rv1106-legacy-distro-boot-env.patch \
" 
