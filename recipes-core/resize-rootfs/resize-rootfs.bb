SUMMARY = "Grow the root filesystem to fill the boot medium on first boot"
DESCRIPTION = "The .wic images are built to a fixed size, leaving part of the \
SD card unused. This installs a one-shot init script that expands the root \
partition and filesystem to the end of the device the first time the board \
boots."
HOMEPAGE = "https://github.com/rzeldent/meta-rv110x"
SECTION = "base"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://resize-rootfs.sh \
    file://init \
"

S = "${UNPACKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "resize-rootfs"
# Run after the root filesystem is mounted read-write and /var/lib exists.
INITSCRIPT_PARAMS = "start 40 S ."

RDEPENDS:${PN} += "e2fsprogs-resize2fs util-linux-sfdisk util-linux-partx util-linux-findmnt"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/resize-rootfs.sh ${D}${sbindir}/resize-rootfs

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${UNPACKDIR}/init ${D}${sysconfdir}/init.d/resize-rootfs
}
