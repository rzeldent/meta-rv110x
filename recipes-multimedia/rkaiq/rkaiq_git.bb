SUMMARY = "Rockchip camera engine (ISP 3A / RKAIQ) for RV1106"
DESCRIPTION = "Rockchip RKAIQ built from source"
HOMEPAGE = "https://github.com/JeffyCN/mirrors"
SECTION = "libs/multimedia"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://NOTICE;md5=9645f39e9db895a4aa6e02cb57294595"

SRC_URI = "git://github.com/JeffyCN/mirrors.git;nobranch=1;protocol=https"
SRCREV = "bd19d1ee0d4c21945f156f75a8eb1cdafed2777a"
PV = "5.0+git"

inherit cmake pkgconfig

COMPATIBLE_HOST = "arm.*-linux.*"

DEPENDS = "libdrm rga coreutils-native m4-native xxd-native"

# Only the 3A library; the demos and tool servers are not needed
OECMAKE_SOURCEPATH = "${S}/rkaiq"

EXTRA_OECMAKE = " \
    -DRKAIQ_TARGET_SOC=rv1106 \
    -DISP_HW_VERSION=-DISP_HW_V32 \
    -DRKAIQ_ENABLE_CAMGROUP=TRUE \
    -DRKAIQ_ENABLE_LIBDRM=OFF \
    -DRKAIQ_ENABLE_AF=ON \
    -DARCH=arm \
    -DCMAKE_BUILD_TYPE=Release \
"

do_configure:prepend() {
    # Let OE's -mcpu/-mfpu apply and keep warnings from failing the build
    sed -i '/-march=armv7-a/d; s/ -Werror//' ${S}/rkaiq/cmake/CompileOptions.cmake
    # The header pre-processing step calls the cross compiler directly: give it the sysroot flags
    sed -i 's#COMMAND ${CMAKE_C_COMPILER}$#COMMAND ${CMAKE_C_COMPILER} ${RKAIQ_CPP_FLAGS}#; 1a separate_arguments(RKAIQ_CPP_FLAGS UNIX_COMMAND "${CMAKE_C_FLAGS}")' ${S}/rkaiq/iq_parser_v2/CMakeLists.txt
    # Pre-processed system headers live below the sysroot rather than directly in /usr
    sed -i 's#"\\/usr\\/#"[^"]*\\/usr\\/\\(include\\|lib\\)\\/#' ${S}/rkaiq/tools/iq_check/script/header_strip.sh
}

# The compile flags come from OE's cmake toolchain file; -Werror removal above is not enough for 3rd-party warnings
CXXFLAGS:append = " -Wno-error -include cstdio -include cstdint -include cstring -include cstdlib"

# librkaiq.so is not versioned, so ship it in the main package
SOLIBS = ".so"
FILES_SOLIBSDEV = ""
INSANE_SKIP:${PN} += "32bit-time"
