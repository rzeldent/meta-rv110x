#!/bin/sh
#
# Grow the root partition and filesystem to fill the boot medium.
#
# The .wic images are built to a fixed size, so a freshly flashed card leaves
# the remainder of the card unused. This runs once on first boot and expands
# the rootfs to the end of the device; later boots are a no-op thanks to the
# flag file.

set -e

FLAG=/var/lib/resize-rootfs.done

[ -e "$FLAG" ] && exit 0

# Resolve the block device backing /, e.g. /dev/mmcblk0p9
ROOTDEV="$(findmnt -n -o SOURCE /)"
[ -b "$ROOTDEV" ] || { echo "resize-rootfs: cannot resolve root device" >&2; exit 1; }

# Split it into disk and partition number. Covers both mmcblk0p9 and sda9.
case "$ROOTDEV" in
    *p[0-9]*) DISK="${ROOTDEV%p*}"; PART="${ROOTDEV##*p}" ;;
    *[0-9])   DISK="${ROOTDEV%[0-9]*}"; PART="${ROOTDEV##*[!0-9]}" ;;
    *) echo "resize-rootfs: unexpected root device '$ROOTDEV'" >&2; exit 1 ;;
esac

echo "resize-rootfs: growing $ROOTDEV (partition $PART on $DISK)"

# The wic layout leaves rootfsA as the last partition, so it can simply absorb
# the remaining space. --no-tell-kernel stops sfdisk from trying to update a
# partition table that is in use.
printf ',+,\n' | sfdisk --no-reread --no-tell-kernel -N "$PART" "$DISK"

# Tell the kernel about the new size. resizepart uses the BLKPG ioctl, which
# works on a partition that is currently mounted; partx is a fallback.
if command -v resizepart >/dev/null 2>&1; then
    resizepart "$DISK" "$PART" || true
else
    partx -u "$DISK" 2>/dev/null || true
fi

# The kernel may still report the old size for the mounted root device, so grow
# the filesystem online.
if ! resize2fs "$ROOTDEV"; then
    echo "resize-rootfs: resize2fs failed; will retry on next boot" >&2
    exit 0
fi

mkdir -p "$(dirname "$FLAG")"
touch "$FLAG"
echo "resize-rootfs: done"
