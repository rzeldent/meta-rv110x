# meta-rv110x

Yocto BSP layer for Rockchip boards based on RV1103/RV1106.

## 📋 Description


![plot](files/img/fastfetch.png)

The purpose of this layer is to provide OpenEmbedded BSP support for
Rockchip boards based on RV1103/RV1106 using ported rockchip-linux sources.

## 🛹 Supported boards
| Name                | Link                                          | View     |
:--------------------:|:---------------------------------------------:|:-----------:
| Luckfox Pico        | <https://www.luckfox.com/Luckfox-Pico>        | <img src="files/img/luckfox-pico.jpg" width="40%">|
| Luckfox Pico SPI NAND | <https://www.luckfox.com/Luckfox-Pico>      | <img src="files/img/luckfox-pico.jpg" width="40%">|
| Luckfox Pico Plus   | <https://www.luckfox.com/Luckfox-Pico-Plus>   | <img src="files/img/luckfox-pico-plus.jpg" width="40%">|
| Luckfox Pico Plus SPI NAND | <https://www.luckfox.com/Luckfox-Pico-Plus> | <img src="files/img/luckfox-pico-plus.jpg" width="40%">|
| Luckfox Pico Max    | <https://www.luckfox.com/Luckfox-Pico-Max>    | <img src="files/img/luckfox-pico-max.jpg" width="40%">|
| Luckfox Pico Max SPI NAND | <https://www.luckfox.com/Luckfox-Pico-Max> | <img src="files/img/luckfox-pico-max.jpg" width="40%">|
| Luckfox Pico Mini A | <https://www.luckfox.com/Luckfox-Pico-Mini-A> | <img src="files/img/luckfox-pico-mini-a.jpg" width="40%">|
| Luckfox Pico Mini B | <https://www.luckfox.com/Luckfox-Pico-Mini-B> | <img src="files/img/luckfox_pico_mini_b.png" width="40%">|

## 🔧 Development status
- [x] 🚀 Initial support in u-boot
- [x] ✈️ Initial support in linux kernel
- [x] 🌐 Ethernet with static MAC
- [x] 📼 Boot from NAND
- [x] 🔌 USB host and gadget support
- [ ] 📷 Camera serial interface (added but not tested)
- [ ] 📥 RAUC support for SD card
- [ ] 📥 RAUC support for NAND
- [ ] 📺 Support for some display controllers

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