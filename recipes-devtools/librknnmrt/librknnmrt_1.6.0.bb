SUMMARY = "Rockchip RKNN mini runtime (librknnmrt) for RV1103/RV1106"
DESCRIPTION = "Prebuilt RKNN inference runtime matching the rknpu kernel driver \
(0.9.x) used by this layer, plus the public RKNN API headers."
HOMEPAGE = "https://github.com/airockchip/rknn-toolkit2"
SECTION = "libs"

# The runtime is a prebuilt binary taken from the Luckfox SDK glibc overlay.
# The licence and headers are from the RKNN-Toolkit2 v1.6.0 release.
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=ac8e7324c36d977f97238dc97a7042f3"

LUCKFOX_SDK_REV = "824b817f889c2cbff1d48fcdb18ab494a68f69d1"
RKNN_TOOLKIT_REV = "b25dadacc24b88eb7dfcaa47c9c525ecca89b319"
RKNN_API_URL = "https://raw.githubusercontent.com/airockchip/rknn-toolkit2/${RKNN_TOOLKIT_REV}/rknpu2/runtime/Linux/librknn_api/include"

SRC_URI = " \
    https://raw.githubusercontent.com/LuckfoxTECH/luckfox-pico/${LUCKFOX_SDK_REV}/project/cfg/BoardConfig_IPC/overlay/overlay-luckfox-glibc-rockchip/usr/lib/librknnmrt.so;name=lib \
    ${RKNN_API_URL}/rknn_api.h;name=api \
    ${RKNN_API_URL}/rknn_custom_op.h;name=customop \
    ${RKNN_API_URL}/rknn_matmul_api.h;name=matmul \
    https://raw.githubusercontent.com/airockchip/rknn-toolkit2/${RKNN_TOOLKIT_REV}/LICENSE;name=license \
"
SRC_URI[lib.sha256sum] = "3776739c9bd0d3dab33c3f7c64b63596b0f1284f1ebd9874176673290fb55561"
SRC_URI[api.sha256sum] = "5dd298529d6b2e43dec0deba824c90472c289e9a13c4ef598658bdb9c7273cb2"
SRC_URI[customop.sha256sum] = "f142cc4e0449526064019695d8a3684da38c1a856cb3600b6eabc35c1f27acf7"
SRC_URI[matmul.sha256sum] = "a56d8bb5e82b0a6afdc21dbb775448c8ec8808044ec9400d2c016f079ec37eb9"
SRC_URI[license.sha256sum] = "7fc60f3387179291c6f781d9e0931a30c710e34131699b7f5d3dfa2cfa5bb0c0"

S = "${UNPACKDIR}"

COMPATIBLE_HOST = "arm.*-linux.*"
# The prebuilt library is linked against glibc.
COMPATIBLE_HOST:libc-musl = "null"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${libdir} ${D}${includedir}
    install -m 0755 ${S}/librknnmrt.so ${D}${libdir}/librknnmrt.so
    install -m 0644 ${S}/rknn_api.h ${S}/rknn_custom_op.h ${S}/rknn_matmul_api.h ${D}${includedir}/
}

# The library has an unversioned soname and is needed at runtime.
SOLIBS = ".so"
FILES_SOLIBSDEV = ""
FILES:${PN} = "${libdir}/librknnmrt.so"
INSANE_SKIP:${PN} += "already-stripped ldflags"

RDEPENDS:${PN} += "kernel-module-rknpu"
