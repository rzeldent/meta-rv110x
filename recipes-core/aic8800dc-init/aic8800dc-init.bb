SUMMARY = "AIC8800DC WiFi/BT init scripts"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://wifi_bt_init.sh \
           file://hciinit"

S = "${UNPACKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "hciinit"
INITSCRIPT_PARAMS = "start 99 S ."

do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${S}/hciinit ${D}${sysconfdir}/init.d/

    install -d ${D}${sysconfdir}/wifi
    install -m 0755 ${S}/wifi_bt_init.sh ${D}${sysconfdir}/wifi/
}

RDEPENDS:${PN} += "aic8800dc-driver aic8800dc-firmware iproute2 wireless-regdb-static"
