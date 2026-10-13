FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS:prepend := "${RV110X_DTS}:"

require recipes-kernel/linux/linux-rockchip.inc

KBRANCH:luckfox-pico-mini = "v7.1/standard/base"
KBRANCH:luckfox-pico-mini-a = "v7.1/standard/base"
KBRANCH:luckfox-pico-mini-b = "v7.1/standard/base"
KBRANCH:luckfox-pico = "v7.1/standard/base"
KBRANCH:luckfox-pico-spi-nand = "v7.1/standard/base"
KBRANCH:luckfox-pico-plus = "v7.1/standard/base"
KBRANCH:luckfox-pico-plus-spi-nand = "v7.1/standard/base"
KBRANCH:luckfox-pico-max = "v7.1/standard/base"
KBRANCH:luckfox-pico-max-spi-nand = "v7.1/standard/base"

SRCREV_machine:luckfox-pico-mini = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico-mini = "0a0706de0ba02be2cac13def96a65b40a52666bc"
SRCREV_machine:luckfox-pico-mini-a = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico-mini-a = "0a0706de0ba02be2cac13def96a65b40a52666bc"
SRCREV_machine:luckfox-pico-mini-b = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico-mini-b = "0a0706de0ba02be2cac13def96a65b40a52666bc"
SRCREV_machine:luckfox-pico = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico = "0a0706de0ba02be2cac13def96a65b40a52666bc"
SRCREV_machine:luckfox-pico-spi-nand = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico-spi-nand = "0a0706de0ba02be2cac13def96a65b40a52666bc"
SRCREV_machine:luckfox-pico-plus = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico-plus = "0a0706de0ba02be2cac13def96a65b40a52666bc"
SRCREV_machine:luckfox-pico-plus-spi-nand = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico-plus-spi-nand = "0a0706de0ba02be2cac13def96a65b40a52666bc"
SRCREV_machine:luckfox-pico-max = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico-max = "0a0706de0ba02be2cac13def96a65b40a52666bc"
SRCREV_machine:luckfox-pico-max-spi-nand = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta:luckfox-pico-max-spi-nand = "0a0706de0ba02be2cac13def96a65b40a52666bc"

LINUX_VERSION:luckfox-pico-mini = "7.1"
LINUX_VERSION:luckfox-pico-mini-a = "7.1"
LINUX_VERSION:luckfox-pico-mini-b = "7.1"
LINUX_VERSION:luckfox-pico = "7.1"
LINUX_VERSION:luckfox-pico-spi-nand = "7.1"
LINUX_VERSION:luckfox-pico-plus = "7.1"
LINUX_VERSION:luckfox-pico-plus-spi-nand = "7.1"
LINUX_VERSION:luckfox-pico-max = "7.1"
LINUX_VERSION:luckfox-pico-max-spi-nand = "7.1"


COMPATIBLE_MACHINE:luckfox-pico-mini = "luckfox-pico-mini"
COMPATIBLE_MACHINE:luckfox-pico-mini-a = "luckfox-pico-mini-a"
COMPATIBLE_MACHINE:luckfox-pico-mini-b = "luckfox-pico-mini-b"
COMPATIBLE_MACHINE:luckfox-pico = "luckfox-pico"
COMPATIBLE_MACHINE:luckfox-pico-spi-nand = "luckfox-pico-spi-nand"
COMPATIBLE_MACHINE:luckfox-pico-plus = "luckfox-pico-plus"
COMPATIBLE_MACHINE:luckfox-pico-plus-spi-nand = "luckfox-pico-plus-spi-nand"
COMPATIBLE_MACHINE:luckfox-pico-max = "luckfox-pico-max"
COMPATIBLE_MACHINE:luckfox-pico-max-spi-nand = "luckfox-pico-max-spi-nand"

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
    file://rv1103g-luckfox-pico-mini-a.dts \
    file://rv1103g-luckfox-pico-mini-b.dts \
    file://rv1103g-luckfox-pico-mini.dtsi \
    file://rv1103g.dtsi \
    file://rv1106-luckfox-pico.dts \
    file://rv1106-luckfox-pico-plus.dts \
    file://rv1106g-luckfox-pico-pro-max.dts \
    file://rv1106-luckfox-pico-pro-max-ipc.dtsi \
    file://rv1103-luckfox-pico-ipc.dtsi \
    file://rv1106-evb.dtsi \
    file://rv1106-amp.dtsi \
    file://rv1106-pinctrl.dtsi \
    file://rv1106.dtsi \
"

do_configure:append() {
    cp ${UNPACKDIR}/rv1103g-luckfox-pico-mini-a.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1103g-luckfox-pico-mini-b.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1103g-luckfox-pico-mini.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1103g.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106-luckfox-pico.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106-luckfox-pico-plus.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106g-luckfox-pico-pro-max.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106-luckfox-pico-pro-max-ipc.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1103-luckfox-pico-ipc.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106-pinctrl.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106.dtsi ${S}/arch/arm/boot/dts/rockchip/
}
