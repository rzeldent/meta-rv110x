SUMMARY = "Rockchip IPC application for RV1103/RV1106"
DESCRIPTION = "RKIPC application from Luckfox SDK - provides RTSP streaming with hardware encoding"
HOMEPAGE = "https://github.com/LuckfoxTECH/luckfox-pico"
SECTION = "multimedia"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4624a9f55b8d2825dcc7f72baeb6fc80"

LUCKFOX_SDK_REV = "824b817f889c2cbff1d48fcdb18ab494a68f69d1"

SRC_URI = " \
    file://glibc-compat.c \
    git://github.com/LuckfoxTECH/luckfox-pico.git;branch=main;protocol=https;destsuffix=git/luckfox-pico \
"
SRCREV = "${LUCKFOX_SDK_REV}"

S = "${UNPACKDIR}/git/luckfox-pico/project/app/rkipc/rkipc"

# rockit_full includes: rockit, rkmuxer, rksysutils, rkaudio, aec_bf_process, rkaudio_detect, rockiva, iconv
DEPENDS = "libdrm rockchip-mpp rockit rkaiq rga rtsp librknnmrt freetype wpa-supplicant"

inherit cmake pkgconfig

# The SDK uses uclibc toolchain, but we're building for glibc
# We need to adjust the link directories
SDK_INC = "${UNPACKDIR}/git/luckfox-pico/media"
TARGET_CFLAGS:append = " -I${WORKDIR}/sdk-include \
    -I${SDK_INC}/common_algorithm/common_algorithm/misc/include \
    -I${SDK_INC}/sysutils/include \
    -I${SDK_INC}/rockit/rockit/mpi/sdk/include \
    -I${STAGING_INCDIR}/freetype2 \
    -I${STAGING_INCDIR}/rkaiq -I${STAGING_INCDIR}/rkaiq/uAPI2 -I${STAGING_INCDIR}/rkaiq/common \
    -I${STAGING_INCDIR}/rkaiq/xcore -I${STAGING_INCDIR}/rkaiq/algos -I${STAGING_INCDIR}/rkaiq/iq_parser \
    -I${STAGING_INCDIR}/rkaiq/iq_parser_v2 -I${STAGING_INCDIR}/rkaiq/isp -I${STAGING_INCDIR}/rkaiq/ipc_server \
    -U_TIME_BITS -Wno-error=format-security -Wno-error=implicit-function-declaration -Wno-error=int-conversion -Wno-error=incompatible-pointer-types"

# Prebuilt static libs contain non-PIC absolute relocations
SECURITY_CFLAGS = "${SECURITY_NOPIE_CFLAGS}"
SECURITY_LDFLAGS = "${SECURITY_NOPIE_LDFLAGS}"
TARGET_LDFLAGS:append = " -no-pie"

EXTRA_OECMAKE = " \
    -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=BOTH \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=BOTH \
    -DCOMPILE_FOR_RV1103_IPC=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_SKIP_RPATH=ON \
"

# Adapt the SDK's uclibc-specific CMake to the Yocto sysroot
do_configure:prepend() {
    # Prebuilt glibc libs and headers shipped in the SDK tree
    SDK=${UNPACKDIR}/git/luckfox-pico
    HDR=${WORKDIR}/sdk-include
    LIBS=${WORKDIR}/sdk-lib
    rm -rf ${HDR} ${LIBS}; mkdir -p ${HDR} ${LIBS}
    ln -s $SDK/media/iva/iva/librockiva/rockiva-rv1106-Linux/include ${HDR}/rockiva
    MISC=$SDK/media/common_algorithm/common_algorithm/misc/lib/arm-rockchip830-linux-gnueabihf
    ALG=$SDK/media/common_algorithm/common_algorithm/audio/rkaudio_algorithms/lib32
    cp $MISC/librkaudio.a $MISC/librkmuxer.so ${LIBS}/
    cp $ALG/librkaudio_detect.a $ALG/libaec_bf_process.a ${LIBS}/
    cp $SDK/media/iva/iva/librockiva/rockiva-rv1106-Linux/lib/librockiva.a ${LIBS}/

    # Luckfox's closed rkaiq has a thunderboot API (rk_aiq_tb_info_t) the public rkaiq source lacks
    sed -i '/rk_aiq_tb_info_t tb_info;/,/rk_aiq_uapi2_sysctl_preInit_tb_info/d' ${S}/common/isp/rv1106/isp.c

    CML=${S}/src/rv1103_ipc/CMakeLists.txt
    sed -i '/link_directories.*uclibcgnueabihf/d; /libwpa_client.so/d' $CML
    sed -i 's#rkaudio)$#rkaudio drm)#; s# iconv rknnmrt# rknnmrt#' $CML
    sed -i 's#^add_definitions(-DISP_HW_V32)#link_directories(${CMAKE_SYSROOT}${libdir} ${WORKDIR}/sdk-lib)\n&#' $CML
}

do_compile:prepend() {
    # librksysutils from SDK sources, plus a shim for a symbol glibc no longer exports
    SU=${UNPACKDIR}/git/luckfox-pico/media/sysutils
    mkdir -p ${WORKDIR}/sysutils-build && cd ${WORKDIR}/sysutils-build
    for f in ${SU}/src/*.c ${UNPACKDIR}/glibc-compat.c; do
        ${CC} ${CFLAGS} -I${SU}/include -I${STAGING_INCDIR}/rockchip -c $f
    done
    ${AR} cr ${WORKDIR}/sdk-lib/librksysutils.a *.o
    cd ${B}
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/src/rv1103_ipc/rkipc ${D}${bindir}/rkipc
    install -d ${D}${libdir}
    install -m 0755 ${WORKDIR}/sdk-lib/librkmuxer.so ${D}${libdir}/librkmuxer.so
    install -d ${D}${datadir}/rkipc
    install -m 0644 ${S}/src/rv1103_ipc/rkipc-300w.ini ${D}${datadir}/rkipc/
    install -m 0644 ${S}/src/rv1103_ipc/rkipc-400w.ini ${D}${datadir}/rkipc/
    install -m 0644 ${S}/common/speaker_test.wav ${D}${datadir}/rkipc/
    install -m 0755 ${S}/src/rv1103_ipc/RkLunch.sh ${D}${bindir}/
    install -m 0755 ${S}/src/rv1103_ipc/RkLunch-stop.sh ${D}${bindir}/
    install -m 0644 ${S}/common/osd/image.bmp ${D}${datadir}/rkipc/
    install -m 0644 ${S}/common/osd/simsun_en.ttf ${D}${datadir}/rkipc/
}

FILES:${PN} += "${datadir}/rkipc ${libdir}/librkmuxer.so"
# librkmuxer.so is an unversioned runtime library
SOLIBS = ".so"
FILES_SOLIBSDEV = ""
INSANE_SKIP:${PN} += "32bit-time build-deps dev-so already-stripped ldflags file-rdeps textrel"

# rockchip-mpp, rockit, rkaiq and rtsp are static libs linked into rkipc
RDEPENDS:${PN} = "rga librknnmrt freetype wpa-supplicant kernel-module-rknpu"
