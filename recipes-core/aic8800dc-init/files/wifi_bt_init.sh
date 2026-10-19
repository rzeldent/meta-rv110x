#!/bin/sh

# AIC8800DC WiFi/BT initialization script
# Based on luckfox-pico project/cfg/BoardConfig_IPC/overlay/overlay-luckfox-glibc-ultra/usr/bin/wifi_bt_init.sh

# The AIC8800DC module is optional: it plugs into the SD card slot. If it is
# not present the SDIO probe simply never happens, so there is nothing to gate
# on here beyond the modules being installed.

if [ "$1" = "stop" ]; then
    pkill -f "udhcpc -i wlan0"
    pkill -f "wpa_supplicant"
    rmmod aic8800_btlpm 2>/dev/null
    rmmod aic8800_fdrv 2>/dev/null
    rmmod aic8800_bsp 2>/dev/null
    rmmod cfg80211 2>/dev/null
    exit 0
fi

# Load kernel modules
MODDIR=/lib/modules/$(uname -r)/kernel/drivers/net/wireless/aic8800
if [ -d "$MODDIR" ]; then
    if [ -z "$(ifconfig | grep wlan0)" ]; then
        echo "Loading AIC8800DC WiFi/BT modules..."
        modprobe cfg80211 2>/dev/null || true
        modprobe libarc4 2>/dev/null || true
        modprobe ctr 2>/dev/null || true
        modprobe ccm 2>/dev/null || true
        modprobe aes_generic 2>/dev/null || true
        insmod "$MODDIR/aic8800_bsp.ko"
        sleep 0.2
        insmod "$MODDIR/aic8800_fdrv.ko"
        sleep 2
        insmod "$MODDIR/aic8800_btlpm.ko"
    fi
else
    echo "Missing AIC8800DC kernel modules!"
    exit 1
fi

# Clean up wpa_supplicant socket
if [ -d /var/run/wpa_supplicant ]; then
    rm -rf /var/run/wpa_supplicant
fi

# Start wpa_supplicant if config exists
if [ -f /etc/wpa_supplicant.conf ] && [ -n "$(ifconfig | grep wlan0)" ]; then
    wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf >/dev/null
    chmod a+x /usr/share/udhcpc/default.script
fi