FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

ALTERNATIVE:${PN} += "flash_erase"
ALTERNATIVE_LINK_NAME[flash_erase] = "${sbindir}/flash_erase"