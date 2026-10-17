#!/bin/sh
#
# Present the board to a USB host as a CDC-ACM serial port. The kernel exposes
# the port as /dev/ttyGS0, which the machine's SERIAL_CONSOLES gives a getty, so
# the board can be logged into over the same USB port it is powered from.
#
# The device tree selects dr_mode = "peripheral" for the DWC3 controller, so the
# port acts as a USB device rather than a host.

set -e

GADGET=/sys/kernel/config/usb_gadget/luckfox
CONFIGFS=/sys/kernel/config

# configfs and the composite gadget stack are modules in this kernel. Loading
# configfs is also what makes /sys/kernel/config appear: the driver registers it
# as a sysfs mount point, so it must not be created with mkdir (sysfs is
# read-only, and mkdir there fails with EPERM).
modprobe configfs 2>/dev/null || true
mount -t configfs configfs "$CONFIGFS" 2>/dev/null || true
modprobe libcomposite 2>/dev/null || true

if [ ! -d "$CONFIGFS/usb_gadget" ]; then
    echo "usb-gadget-serial: configfs gadget support unavailable" \
         "(is the configfs module available?)" >&2
    exit 1
fi

# The function's tty only appears once a controller is bound, so there is no
# point building the gadget without one. The controller is built in and normally
# probes before init runs; wait briefly in case an extcon dependency resolved
# late.
UDC_NAME="$(ls /sys/class/udc 2>/dev/null | head -n 1)"
tries=0
while [ -z "$UDC_NAME" ] && [ "$tries" -lt 5 ]; do
    sleep 1
    tries=$((tries + 1))
    UDC_NAME="$(ls /sys/class/udc 2>/dev/null | head -n 1)"
done

if [ -z "$UDC_NAME" ]; then
    echo "usb-gadget-serial: no USB device controller available" >&2
    exit 1
fi

mkdir -p "$GADGET"
cd "$GADGET"

# 0x1d6b/0x0104 is the Linux Foundation multifunction composite gadget pair.
echo 0x1d6b > idVendor
echo 0x0104 > idProduct
echo 0x0100 > bcdDevice
echo 0x0200 > bcdUSB

SERIAL="$(cat /sys/devices/soc0/serial_number 2>/dev/null || true)"
mkdir -p strings/0x409
echo "Luckfox" > strings/0x409/manufacturer
echo "Luckfox USB serial" > strings/0x409/product
echo "${SERIAL:-0}" > strings/0x409/serialnumber

mkdir -p configs/c.1/strings/0x409
echo "CDC ACM" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower

# Creating the function makes the kernel load the usb_f_acm module.
mkdir -p functions/acm.usb0
ln -sf functions/acm.usb0 configs/c.1/

echo "$UDC_NAME" > UDC
