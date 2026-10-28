SUMMARY = "Rockchip RGA (2D raster graphic acceleration) library"
DESCRIPTION = "librga and the im2d API for Rockchip SoCs, built from source"
HOMEPAGE = "https://github.com/JeffyCN/mirrors/tree/linux-rga-multi"
SECTION = "libs/multimedia"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "git://github.com/JeffyCN/mirrors.git;branch=linux-rga-multi;protocol=https"
SRCREV = "57a1067a246c71fa6c9a355d1668884fda155dd5"
PV = "2.1.0+git"

DEPENDS = "libdrm"

inherit meson pkgconfig

COMPATIBLE_HOST = "arm.*-linux.*"
COMPATIBLE_HOST:libc-musl = "null"
