# Add rkmpp support to ffmpeg for Rockchip hardware encoding/decoding
# This requires the rockchip-mpp library and libdrm

PACKAGECONFIG:append:rockchip = " rkmpp"

PACKAGECONFIG[rkmpp] = "--enable-rkmpp --enable-libdrm --enable-version3,--disable-rkmpp,rockchip-mpp libdrm"

# The rkmpp encoder (h264_rkmpp, hevc_rkmpp) was added in ffmpeg master after 8.0
# We need to use a newer version or the rockchip fork
# For now, we'll add the configure option and it will work for decoding
# For encoding, we need ffmpeg >= 7.1 or the rockchip fork

# Add rockchip-mpp to DEPENDS when rkmpp is enabled
DEPENDS:append:rockchip = " ${@bb.utils.contains('PACKAGECONFIG', 'rkmpp', 'rockchip-mpp libdrm', '', d)}"

# Also need to ensure the headers are found
EXTRA_OECONF:append:rockchip = " ${@bb.utils.contains('PACKAGECONFIG', 'rkmpp', ' --enable-rkmpp --enable-libdrm', '', d)}"