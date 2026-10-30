SUMMARY = "SmartSens SC3336 CMOS Image Sensor Driver"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit module

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://sc3336.c;subdir=sc3336-driver-1.0 \
    file://Kbuild;subdir=sc3336-driver-1.0 \
"

S = "${UNPACKDIR}/sc3336-driver-1.0"

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
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/media/i2c
    install -m 0644 ${S}/sc3336.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/media/i2c/sc3336.ko
}

RPROVIDES:${PN} = "kernel-module-sc3336"