# meta-rv110x

Yocto BSP layer for Rockchip boards based on RV1103/RV1106.

## 📋 Description

The purpose of this layer is to provide OpenEmbedded BSP support for
Rockchip boards based on RV1103/RV1106 using ported rockchip-linux sources.

## 🛹 Supported boards
| Name                | Link                                          | GPIO     |
:--------------------:|:---------------------------------------------:|:-----------:
| Luckfox Pico        | <https://www.luckfox.com/Luckfox-Pico>        | <img src="files/img/luckfox-pico-gpio.jpg" width="40%">|
| Luckfox Pico SPI NAND | <https://www.luckfox.com/Luckfox-Pico>      | <img src="files/img/luckfox-pico-gpio.jpg" width="40%">|
| Luckfox Pico Plus   | <https://www.luckfox.com/Luckfox-Pico-Plus>   | <img src="files/img/luckfox-pico-plus-gpio.jpg" width="40%">|
| Luckfox Pico Plus SPI NAND | <https://www.luckfox.com/Luckfox-Pico-Plus> | <img src="files/img/luckfox-pico-plus-gpio.jpg" width="40%">|
| Luckfox Pico Max    | <https://www.luckfox.com/Luckfox-Pico-Max>    | <img src="files/img/luckfox-pico-pro-gpio.jpg" width="40%">|
| Luckfox Pico Max SPI NAND | <https://www.luckfox.com/Luckfox-Pico-Max> | <img src="files/img/luckfox-pico-pro-gpio.jpg" width="40%">|
| Luckfox Pico Mini A | <https://www.luckfox.com/Luckfox-Pico-Mini-A> | <img src="files/img/luckfox-pico-mini-gpio.jpg" width="40%">|
| Luckfox Pico Mini B | <https://www.luckfox.com/Luckfox-Pico-Mini-B> | <img src="files/img/luckfox-pico-mini-gpio.jpg" width="40%">|

## 🔧 Development status
- [x] 🚀 Initial support in u-boot
- [x] ✈️ Initial support in linux kernel
- [x] 🌐 Ethernet with static MAC
- [x] 📼 Boot from NAND
- [x] 🔌 USB host and gadget support
- [x] 📷 Camera serial interface (SC3336) on all boards
- [ ] 📥 RAUC support for SD card
- [ ] 📥 RAUC support for NAND
- [ ] 📺 Support for some display controllers

## 📷 Camera (SC3336 on MIPI CSI)

Every machine enables the vendor camera stack, so attaching a Smartsens SC3336
module to the board's MIPI CSI connector works without any extra configuration:

```
SC3336 -> CSI2 DPHY (2 lanes, 510 Mbps) -> MIPI CSI2 receiver -> CIF -> /dev/video0
```

This needs no dedicated machine; the device tree of every board describes the
camera and the image carries four modules: `sc3336`,
`phy-rockchip-csi2-dphy`, `phy-rockchip-csi2-dphy-hw` and
`rockchip-cif-vendor`, plus `v4l-utils` and `i2c-tools` for debugging. Boards
without a camera attached still boot normally, the sensor simply fails to probe.

### Capturing a frame

There is no ISP driver in this kernel, so the CIF hands out the raw Bayer data of
the sensor's only mode, 2304x1296 @ 30 fps:

```sh
v4l2-ctl -d /dev/video0 --set-fmt-video=width=2304,height=1296,pixelformat=BG10 \
  --stream-mmap=2 --stream-count=1 --stream-to=/tmp/frame.raw
```

The layout is Rockchip "compact" RAW10: 4 pixels packed in 5 bytes, and each
line padded to a 256-byte boundary (`ALIGN(2304 * 10 / 8, 256) = 3072`), so a
frame is `3072 * 1296 = 3981312` bytes. Use `media-ctl -p` to inspect the media
graph and `cat /proc/rkcif-mipi-lvds` for the clock/error statistics.

### Board specific requirements

Three things are non-obvious and easy to break when touching the DTS:

* **I2C pull-ups.** The camera modules do not provide any, so `i2c4` uses the
  `i2c4_cam_xfer` pin group (100 kHz, `&pcfg_pull_up`) instead of the vendor's
  `i2c4m2_xfer` (`&pcfg_pull_none`). Without this the bus floats and every
  transfer fails with `-ENXIO`, which shows up as
  `sc3336 4-0030: Unexpected sensor id(000000)`.
* **Contiguous DMA memory.** The CIF programs one linear address per plane and
  walks the whole frame from there, so buffers must be physically contiguous.
  `rv1106-camera.dtsi` therefore reserves a 32 MiB reusable CMA pool (one frame
  is ~3.8 MiB) and the driver uses `vb2_dma_contig`. Feeding it scatter-gather
  buffers lets the DMA run into unrelated memory and panics the kernel.
* **GRF window size.** The GRF registers used by the DPHY and the CIF live above
  `0x10000` (`0x50014`, `0x50038`), which is why `peri_grf` in `rv1106.dtsi`
  covers `0x68000` bytes like the vendor's single `grf` node. `regmap_write()`
  silently drops out-of-range writes and the vendor code ignores the error, so a
  too-small window disables the PHY and the CIF input select without a message.

## 🔗 Dependencies
This layer depends on:

* URI: git://git.openembedded.org/openembedded-core
  * branch: walnascar
  * revision: HEAD

* URI: git://git.yoctoproject.org/meta-rockchip
  * branch: walnascar
  * revision: HEAD

## 🙏 Contributing

If you have a desire to help with the development of this layer, or perhaps you would like to help develop patches with soc support for u-boot or linux kernel, then open discussions or pull requests, I would be very glad of any help.

Also, for a quick start, you might find the configured [luckfox-yocto](https://github.com/RamasyaR/luckfox-yocto) project helpful.

## 🦾 Maintainers

* Raman Rakavets `<radikot88@gmail.com>`