FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
FILESEXTRAPATHS:prepend := "${RV110X_DTS}:"

require recipes-kernel/linux/linux-rockchip.inc

# All Luckfox machines use the same kernel branch and revision
KBRANCH = "v7.1/standard/base"
SRCREV_machine = "20319339d760fcb55c7c17ce139db207e5ae7cd3"
SRCREV_meta = "0a0706de0ba02be2cac13def96a65b40a52666bc"
LINUX_VERSION = "7.1"

# All 5 base machines are compatible
COMPATIBLE_MACHINE = "(luckfox-pico(-plus|-max|-mini|-pi)?-(sd-card|spi-nand))"

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
    file://0015-media-i2c-add-smartsens-sc3336-sensor.patch \
    file://0016-phy-rockchip-add-csi2-dphy-driver.patch \
    file://0018-media-rockchip-add-vendor-cif-stack.patch \
    file://0019-drivers-add-rockchip-rknpu.patch \
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
    file://enable-wifi-sdio.cfg \
    file://rfkill-wlan.h \
    file://phy-rockchip-csi2-dphy-common.h \
    file://rkcif-vendor/ \
    file://rknpu/ \
    file://phy-rockchip-csi2-dphy-hw.c \
    file://phy-rockchip-csi2-dphy.c \
    file://phy-rockchip-samsung-dcphy.h \
    file://rkcif-config.h \
    file://rk-camera-module.h \
    file://rk-preisp.h \
    file://rk-video-format.h \
    file://sc3336.c \
    file://rv1103g-luckfox-pico-mini-a.dts \
    file://rv1103g-luckfox-pico-mini-b.dts \
    file://rv1103g-luckfox-pico-mini.dtsi \
    file://rv1103g-luckfox-pico-sd-wifi.dtsi \
    file://rv1103g-luckfox-pico-sd-slot.dtsi \
    file://rv1106-camera.dtsi \
    file://rv1103g.dtsi \
    file://rv1106-luckfox-pico.dts \
    file://rv1106-luckfox-pico-plus.dts \
    file://rv1106g-luckfox-pico-pro-max.dts \
    file://rv1106g-luckfox-pico-pi.dts \
    file://rv1106-luckfox-pico-pro-max-ipc.dtsi \
    file://rv1103-luckfox-pico-ipc.dtsi \
    file://rv1106-evb.dtsi \
    file://rv1106-amp.dtsi \
    file://rv1106-pinctrl.dtsi \
    file://rv1106.dtsi \
"

# Sources must exist before do_kernel_configme evaluates the Kconfig tree.
do_patch:append() {
    cp ${UNPACKDIR}/rk-camera-module.h ${S}/include/uapi/linux/
    cp ${UNPACKDIR}/rk-video-format.h ${S}/include/uapi/linux/
    cp ${UNPACKDIR}/rk-preisp.h ${S}/include/uapi/linux/
    cp ${UNPACKDIR}/sc3336.c ${S}/drivers/media/i2c/
    cp -r ${UNPACKDIR}/rkcif-vendor ${S}/drivers/media/platform/rockchip/
    cp -r ${UNPACKDIR}/rknpu ${S}/drivers/
    install -d ${S}/include/soc/rockchip ${S}/include/linux/soc/rockchip
    install -d ${S}/include/dt-bindings/soc
    cp ${UNPACKDIR}/rkcif-vendor/include/rockchip-system-status-dt.h ${S}/include/dt-bindings/soc/rockchip-system-status.h
    cp ${UNPACKDIR}/rkcif-vendor/include/rk-isp*-config.h ${S}/include/uapi/linux/
    cp ${UNPACKDIR}/rkcif-vendor/include/rk_sdmmc.h ${S}/include/linux/soc/rockchip/
    cp ${UNPACKDIR}/rkcif-vendor/include/rockchip_rockit.h ${S}/include/soc/rockchip/
    cp ${UNPACKDIR}/rkcif-vendor/include/rockchip_iommu.h ${S}/include/soc/rockchip/
    cp ${UNPACKDIR}/rkcif-vendor/include/rockchip-system-status.h ${S}/include/soc/rockchip/
    cp ${UNPACKDIR}/rkcif-vendor/include/rockchip_thunderboot_service.h ${S}/include/linux/soc/rockchip/
    cp ${UNPACKDIR}/rkcif-config.h ${S}/include/uapi/linux/
    cp ${UNPACKDIR}/phy-rockchip-csi2-dphy.c ${S}/drivers/phy/rockchip/
    cp ${UNPACKDIR}/phy-rockchip-csi2-dphy-hw.c ${S}/drivers/phy/rockchip/
    cp ${UNPACKDIR}/phy-rockchip-csi2-dphy-common.h ${S}/drivers/phy/rockchip/
    cp ${UNPACKDIR}/phy-rockchip-samsung-dcphy.h ${S}/drivers/phy/rockchip/
    cp ${UNPACKDIR}/rv1103g-luckfox-pico-mini-a.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1103g-luckfox-pico-mini-b.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1103g-luckfox-pico-mini.dtsi ${S}/arch/arm/boot/dts/rockchip/
    if [ "${@bb.utils.contains_any('LUCKFOX_FEATURES', 'rtl8723bs', '1', '0', d)}" = "1" ]; then
        cp ${UNPACKDIR}/rv1103g-luckfox-pico-sd-wifi.dtsi ${S}/arch/arm/boot/dts/rockchip/rv1103g-luckfox-pico-sdio.dtsi
    else
        cp ${UNPACKDIR}/rv1103g-luckfox-pico-sd-slot.dtsi ${S}/arch/arm/boot/dts/rockchip/rv1103g-luckfox-pico-sdio.dtsi
    fi
    cp ${UNPACKDIR}/rv1106-camera.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1103g.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106-luckfox-pico.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106-luckfox-pico-plus.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106g-luckfox-pico-pro-max.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106g-luckfox-pico-pi.dts ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106-luckfox-pico-pro-max-ipc.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1103-luckfox-pico-ipc.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106-pinctrl.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rv1106.dtsi ${S}/arch/arm/boot/dts/rockchip/
    cp ${UNPACKDIR}/rfkill-wlan.h ${S}/include/linux/
}

SRC_URI:append:npu = " file://enable-rknpu.cfg"
