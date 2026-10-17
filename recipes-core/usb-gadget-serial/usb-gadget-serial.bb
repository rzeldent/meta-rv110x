SUMMARY = "Expose the board as a USB CDC-ACM serial port with a login prompt"
DESCRIPTION = "Installs an init script that creates a configfs USB gadget with a \
CDC-ACM function. The kernel exposes the port as /dev/ttyGS0 and the machine's \
SERIAL_CONSOLES starts a getty on it, so the board can be logged into over the \
USB port it is powered from."
HOMEPAGE = "https://github.com/rzeldent/meta-rv110x"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://usb-gadget-serial.sh \
    file://init \
"

S = "${UNPACKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "usb-gadget-serial"
# Run from rcS (before init opens the runlevel getty entries) so /dev/ttyGS0
# already exists when ttyrun is started for it.
INITSCRIPT_PARAMS = "start 41 S ."

# The gadget stack is modular; pull in only what the ACM gadget needs. These
# packages provide their unsuffixed names, so no kernel version is needed here.
RDEPENDS:${PN} += " \
    kernel-module-configfs \
    kernel-module-libcomposite \
    kernel-module-usb-f-acm \
"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/usb-gadget-serial.sh ${D}${sbindir}/usb-gadget-serial

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${UNPACKDIR}/init ${D}${sysconfdir}/init.d/usb-gadget-serial
}
