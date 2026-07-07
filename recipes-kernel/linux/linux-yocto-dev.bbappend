FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS:prepend := "${RV110X_DTS}:"

require recipes-kernel/linux/linux-rockchip.inc

KBRANCH:luckfox-pico-mini = "v7.1/standard/base"

SRCREV_machine:luckfox-pico-mini = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico-mini = "0a0706de0ba02be2cac13def96a65b40a52666bc"

LINUX_VERSION:luckfox-pico-mini = "7.1"


COMPATIBLE_MACHINE:luckfox-pico-mini = "luckfox-pico-mini"

SRC_URI += " \
    file://0001-dt-bindings-clock-rockchip-add-rv1106-cru-support.patch \
    file://0002-clk-rockchip-add-clock-controller-for-the-rv1106.patch \
    file://0003-clk-rockchip-rv1106-add-reset-lookup-table.patch \
    file://0004-clk-rockchip-rv1106-add-emmc-sd-sdio-tuning-clocks-in-GRF-region.patch \
    file://0005-pinctrl-rockchip-add-rv1106-pinctrl-support.patch \
    file://0006-dt-bindings-nvmem-rockchip-otp-add-compatible-for-rv1106.patch \
    file://0007-nvmem-rockchip-otp-add-support-for-rv1106.patch \
    file://0008-dt-bindings-net-rockchip-dwmac-add-compatible-string-for-rv1106.patch \
    file://0009-ethernet-stmmac-dwmac-rk-add-rv1106-gmac-support.patch \
    file://0010-dt-bindings-phy-rockchip-inno-usb2phy-add-rv1106.patch \
    file://0011-phy-rockchip-inno-usb2-add-usb2-phy-support-for-rv1106.patch \
    file://0012-dt-bindings-phy-rockchip-inno-usb2phy-add-rv1103.patch \
    file://0013-phy-rockchip-inno-usb2-add-usb2-phy-support-for-rv1103.patch \
    file://0014-phy-rockchip-inno-usb2-fix-locate-usbgrf.patch \
    file://apply-rv-optimizations.cfg \
    file://enable-rv-specific-drivers.cfg \
    file://remove-crypto-drivers.cfg \
    file://remove-drm-drivers.cfg \
    file://remove-gpio-drivers.cfg \
    file://remove-leds-drivers.cfg \
    file://remove-mfd-devices-support.cfg \
    file://remove-net-vendor-drivers.cfg \
    file://remove-other-arch-drivers.cfg \
    file://remove-regulator-drivers.cfg \
    file://remove-rtc-drivers.cfg \
    file://remove-serial-drivers.cfg \
    file://remove-snd-drivers.cfg \
    file://remove-usb-drivers.cfg \
    file://remove-wlan-drivers.cfg \
    file://rv1103g-luckfox-pico-mini.dts \
    file://rv1103g.dtsi \
    file://rv1106-pinctrl.dtsi \
    file://rv1106.dtsi \
"

do_configure:append() {
    cp ${UNPACKDIR}/rv1103g-luckfox-pico-mini.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1103g.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106-pinctrl.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106.dtsi ${S}/arch/arm/boot/dts/rockchip/
}
