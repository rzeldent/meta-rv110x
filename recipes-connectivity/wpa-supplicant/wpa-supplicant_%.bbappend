FILESEXTRAPATHS:prepend := "${THISDIR}/wpa-supplicant:"

# Install a custom wpa_supplicant.conf with country code set
# This prevents "regulatory prevented using AP config, downgraded" messages
do_install:append() {
    install -m 600 ${UNPACKDIR}/wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant.conf
}
# rkipc links against libwpa_client.a
DISABLE_STATIC = ""
