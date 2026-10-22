SUMMARY = "RTL8723BS SDIO WiFi driver"
DESCRIPTION = "The rtw88-based RTL8723BS driver and firmware for Realtek SDIO WiFi."
HOMEPAGE = "https://github.com/MocLG/rtw88-rtl8723bs"
LICENSE = "GPL-2.0-only | BSD-3-Clause & Firmware-rtlwifi_firmware"
NO_GENERIC_LICENSE[Firmware-rtlwifi_firmware] = "LICENCE.rtlwifi_firmware.txt"
LIC_FILES_CHKSUM = " \
    file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6 \
    file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9 \
    file://LICENCE.rtlwifi_firmware.txt;md5=c335779b5a1c6bcca9a7f8f36b51e13c \
"

SRC_URI = " \
    git://github.com/MocLG/rtw88-rtl8723bs.git;protocol=https;branch=main \
    file://Kbuild;subdir=rtl8723bs-driver-1.0 \
    file://LICENCE.rtlwifi_firmware.txt;subdir=rtl8723bs-driver-1.0 \
    file://0001-sdio-remove-scan-interrupt-info-log.patch \
"
SRCREV = "47db0929de98cd980744352b37ee3384268476ee"

inherit module

RDEPENDS:${PN} += " \
    kernel-module-rtw-core \
    kernel-module-rtw-8723x \
    kernel-module-rtw-8723b \
    kernel-module-rtw-sdio \
    kernel-module-rtw-8723bs \
"

PACKAGES =+ "rtl8723bs-firmware"
LICENSE:rtl8723bs-firmware = "Firmware-rtlwifi_firmware"
FILES:rtl8723bs-firmware = " \
    ${nonarch_base_libdir}/firmware/rtw88/rtw8723b_fw.bin \
    ${nonarch_base_libdir}/firmware/rtw88/rtw8723b_wow_fw.bin \
"
RDEPENDS:rtl8723bs-firmware += "linux-firmware-rtl-license"

do_compile() {
    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
    oe_runmake -C ${STAGING_KERNEL_DIR} \
        O=${STAGING_KERNEL_BUILDDIR} \
        M=${S} \
        KERNEL_VERSION=${KERNEL_VERSION} \
        CC="${KERNEL_CC}" LD="${KERNEL_LD}" \
        AR="${KERNEL_AR}" OBJCOPY="${KERNEL_OBJCOPY}" \
        STRIP="${KERNEL_STRIP}" \
        KBUILD_EXTRA_SYMBOLS="${KBUILD_EXTRA_SYMBOLS}" \
        modules
}

do_install() {
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/realtek/rtw88
    install -m 0644 ${S}/rtw_core.ko \
        ${S}/rtw_8723x.ko \
        ${S}/rtw_8723b.ko \
        ${S}/rtw_sdio.ko \
        ${S}/rtw_8723bs.ko \
        ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net/wireless/realtek/rtw88/

    install -d ${D}${nonarch_base_libdir}/firmware/rtw88
    install -m 0644 ${S}/firmware/rtw8723b_fw.bin \
        ${S}/firmware/rtw8723b_wow_fw.bin \
        ${D}${nonarch_base_libdir}/firmware/rtw88/
}
