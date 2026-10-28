SUMMARY = "Rockchip RTSP library for RV1103/RV1106"
DESCRIPTION = "Prebuilt RTSP library from Luckfox SDK for streaming"
HOMEPAGE = "https://github.com/rockchip-linux/mpp"
SECTION = "libs/multimedia"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ac8e7324c36d977f97238dc97a7042f3"

LUCKFOX_SDK_REV = "824b817f889c2cbff1d48fcdb18ab494a68f69d1"

SRC_URI = " \
    https://raw.githubusercontent.com/LuckfoxTECH/luckfox-pico/${LUCKFOX_SDK_REV}/project/cfg/BoardConfig_IPC/overlay/overlay-luckfox-glibc-rockchip/usr/lib/librtsp.a;name=lib \
    https://raw.githubusercontent.com/airockchip/rknn-toolkit2/b25dadacc24b88eb7dfcaa47c9c525ecca89b319/LICENSE;name=license \
"
SRC_URI[lib.sha256sum] = "e10621655a7a9a8fccec05f5448a6741dc69315eb89a200c1726522d0f513082"
SRC_URI[license.sha256sum] = "7fc60f3387179291c6f781d9e0931a30c710e34131699b7f5d3dfa2cfa5bb0c0"

S = "${UNPACKDIR}"

COMPATIBLE_HOST = "arm.*-linux.*"
COMPATIBLE_HOST:libc-musl = "null"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${libdir} ${D}${includedir}
    install -m 0644 ${S}/librtsp.a ${D}${libdir}/librtsp.a
}

FILES:${PN} = "${libdir}/librtsp.a"
FILES:${PN}-dev = "${libdir}/librtsp.a ${includedir}"

INSANE_SKIP:${PN} += "already-stripped ldflags staticdev"
