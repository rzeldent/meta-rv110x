#!/bin/sh
#
# RTL8723BS WiFi initialisation (SDIO, rtw88 driver).

start() {
    # Load cfg80211 first with regulatory domain parameter from /etc/modprobe.d/cfg80211.conf
    modprobe cfg80211 || {
        echo "Failed to load cfg80211" >&2
        return 1
    }
    # Disable rtw88 debug logging and LPS to prevent "firmware failed to leave lps state" errors
    modprobe rtw_8723bs debug_mask=0 lps_enable=0 || {
        echo "Failed to load rtw_8723bs" >&2
        return 1
    }

    i=0
    while [ ! -d /sys/class/net/wlan0 ] && [ $i -lt 50 ]; do
        sleep 0.2
        i=$((i + 1))
    done
    if [ ! -d /sys/class/net/wlan0 ]; then
        echo "wlan0 did not appear" >&2
        return 1
    fi

    ip link set dev wlan0 up || return 1

    rm -rf /var/run/wpa_supplicant
    if [ -f /etc/wpa_supplicant.conf ]; then
        wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf >/dev/null
        udhcpc -i wlan0 -b >/dev/null 2>&1 &
    fi
}

stop() {
    killall -q udhcpc
    killall -q wpa_supplicant
    # Wait for wpa_supplicant to exit so it stops queuing frames
    i=0
    while pidof wpa_supplicant >/dev/null 2>&1 && [ $i -lt 25 ]; do
        sleep 0.2
        i=$((i + 1))
    done
    if [ -d /sys/class/net/wlan0 ]; then
        ip addr flush dev wlan0
        ip link set dev wlan0 down
    fi
    # Let pending TX frames get flushed/acked before the hw is freed
    sleep 1
    rmmod rtw_8723bs 2>/dev/null
}

case "$1" in
    start) start ;;
    stop) stop ;;
    restart) stop; start ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac
