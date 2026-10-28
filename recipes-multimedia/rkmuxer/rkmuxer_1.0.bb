SUMMARY = "Rockchip RKMuxer library for RV1103/RV1106 (included in rockit_full)"
DESCRIPTION = "Prebuilt RKMuxer library from Luckfox SDK for media muxing. Note: This is included in rockit_full.a, so this recipe is optional."
HOMEPAGE = "https://github.com/rockchip-linux/mpp"
SECTION = "libs/multimedia"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ac8e7324c36d977f97238dc97a7042f3"

LUCKFOX_SDK_REV = "824b817f889c2cbff1d48fcdb18ab494a68f69d1"

# Note: librkmuxer.a is NOT available in the Luckfox SDK overlay
# It is included in librockit_full.a instead
# This recipe is kept for reference but will fail to fetch
# SRC_URI = " \
#     https://raw.githubusercontent.com/LuckfoxTECH/luckfox-pico/${LUCKFOX_SDK_REV}/project/cfg/BoardConfig_IPC/overlay/overlay-luckfox-glibc-rockchip/usr/lib/librkmuxer.a;name=lib \
#     https://raw.githubusercontent.com/airockchip/rknn-toolkit2/b25dadacc24b88eb7dfcaa47c9c525ecca89b319/LICENSE;name=license \
# "
# SRC_URI[lib.sha256sum] = "SKIP"
# SRC_URI[license.sha256sum] = "7fc60f3387179291c6f781d9e0931a30c710e34131699b7f5d3dfa2cfa5bb0c9"

S = "${UNPACKDIR}"

COMPATIBLE_HOST = "arm.*-linux.*"
COMPATIBLE_HOST:libc-musl = "null"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    # This library is included in rockit_full.a
    # Install a dummy file to satisfy dependencies
    install -d ${D}${libdir}
    echo "This library is included in rockit_full.a" > ${D}${libdir}/librkmuxer.a
}

FILES:${PN} = "${libdir}/librkmuxer.a"
FILES:${PN}-dev = "${libdir}/librkmuxer.a ${includedir}"

INSANE_SKIP:${PN} += "already-stripped ldflags staticdev"
