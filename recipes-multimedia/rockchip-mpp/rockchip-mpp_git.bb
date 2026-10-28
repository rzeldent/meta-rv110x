SUMMARY = "Rockchip MPP (Media Process Platform) library"
DESCRIPTION = "Hardware video encoding/decoding library for Rockchip SoCs, built from source"
HOMEPAGE = "https://github.com/rockchip-linux/mpp"
SECTION = "libs/multimedia"
LICENSE = "Apache-2.0 & MIT"
LIC_FILES_CHKSUM = "file://LICENSES/Apache-2.0;md5=7f43e699e0a26fae98c2938092f008d2 \
                    file://LICENSES/MIT;md5=e8f57dd048e186199433be2c41bd3d6d"

SRC_URI = "git://github.com/rockchip-linux/mpp.git;branch=develop;protocol=https"
SRCREV = "7916c3cc000fefc0bdf96636b7d54fe174724f44"
PV = "1.0+git"

inherit cmake pkgconfig

EXTRA_OECMAKE = " \
    -DRKPLATFORM=ON \
    -DHAVE_DRM=ON \
    -DBUILD_TEST=OFF \
    -DBUILD_SHARED_LIBS=ON \
"

DEPENDS = "libdrm"

COMPATIBLE_HOST = "arm.*-linux.*"
COMPATIBLE_HOST:libc-musl = "null"
