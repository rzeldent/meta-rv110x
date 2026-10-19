SUMMARY = "AIC8800DC WiFi/BT SDIO driver for Rockchip RV1103/RV1106"
DESCRIPTION = "Out-of-tree AIC8800 SDIO WiFi 6 / Bluetooth driver, ported to \
support Linux 7.x kernels."
HOMEPAGE = "https://github.com/radxa-pkg/aic8800"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit module

SRC_URI = "file://Makefile \
           file://Kconfig \
           file://aic8800_bsp \
           file://aic8800_fdrv \
           file://aic8800_btlpm \
           file://aic8800dc_fw"

S = "${UNPACKDIR}"

# The driver Makefile expects KDIR, ARCH and CROSS_COMPILE. The "UBUNTU"
# platform is the generic out-of-tree build path and does not hardcode any
# vendor toolchain.
EXTRA_OEMAKE = "KDIR=${STAGING_KERNEL_BUILDDIR} \
                ARCH=${ARCH} \
                CROSS_COMPILE=${TARGET_PREFIX} \
                CONFIG_PLATFORM_UBUNTU=y \
                KCFLAGS='-ffile-prefix-map=${S}=/usr/src/aic8800dc -ffile-prefix-map=${STAGING_KERNEL_DIR}=/usr/src/kernel'"

do_compile() {
    oe_runmake -C ${S} modules
}

do_install() {
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/aic8800
    install -m 0644 ${S}/aic8800_bsp/aic8800_bsp.ko \
        ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/aic8800/
    install -m 0644 ${S}/aic8800_fdrv/aic8800_fdrv.ko \
        ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/aic8800/
    install -m 0644 ${S}/aic8800_btlpm/aic8800_btlpm.ko \
        ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/aic8800/

    # Firmware is looked up in <CONFIG_AIC_FW_PATH>/aic8800DC
    install -d ${D}${nonarch_base_libdir}/firmware/aic8800_fw/SDIO/aic8800DC
    cp -r ${S}/aic8800dc_fw/. ${D}${nonarch_base_libdir}/firmware/aic8800_fw/SDIO/aic8800DC/
}

# kernel-module-split creates one package per module and makes each of them
# provide the unsuffixed "kernel-module-<name>" alias, so the .ko files must
# not be claimed by the main package.
PACKAGES =+ "${PN}-firmware"
FILES:${PN}-firmware = "${nonarch_base_libdir}/firmware/aic8800_fw/SDIO/aic8800DC/*"

RPROVIDES:${PN}-firmware += "aic8800dc-firmware"
