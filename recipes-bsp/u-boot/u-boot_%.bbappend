FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend := "${RV110X_DTS}:"

SRC_URI += " \
    file://0001-rockchip-mkimage-add-support-for-rv1106.patch \
    file://0002-ram-rockchip-add-basic-support-for-rv1106.patch \
    file://0003-dt-bindings-clock-rockchip-add-rv1106-clock-and-reset-unit.patch \
    file://0004-clk-rockchip-add-support-for-rv1106.patch \
    file://0005-pinctrl-rockchip-add-support-for-rv1106.patch \
    file://0006-arch-arm-rockchip-add-initial-support-for-rv1106.patch \
    file://0007-board-rockchip-add-rv1106-evb.patch \
    file://0008-add-spl-mtd-load-support.patch \
    file://0009-add-rv1106-legacy-distro-boot-env.patch \
    file://0010-rv1106-add-boot-devices.patch \
    file://rv1103g-luckfox-pico-mini-a.dts;subdir=${P}/arch/arm/dts/ \
    file://rv1103g-luckfox-pico-mini-b.dts;subdir=${P}/arch/arm/dts/ \
    file://rv1103g-luckfox-pico-mini.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1103g.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106-luckfox-pico.dts;subdir=${P}/arch/arm/dts/ \
    file://rv1106-luckfox-pico-plus.dts;subdir=${P}/arch/arm/dts/ \
    file://rv1106g-luckfox-pico-pro-max.dts;subdir=${P}/arch/arm/dts/ \
    file://rv1106g-luckfox-pico-pro-max-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106g-luckfox-pico-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106-luckfox-pico-pro-max-ipc.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1103-luckfox-pico-ipc.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106-luckfox-pico-pro-max-ipc.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106-evb.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106-amp.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106-pinctrl.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1103g-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1106-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1103g-luckfox-pico-mini-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1103g-luckfox-pico-mini-a-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://rv1103g-luckfox-pico-mini-b-u-boot.dtsi;subdir=${P}/arch/arm/dts/ \
    file://luckfox-pico-mini-a-rv1103g_defconfig;subdir=${P}/configs/ \
    file://luckfox-pico-mini-b-rv1103g_defconfig;subdir=${P}/configs/ \
    file://luckfox-pico-rv1106_defconfig;subdir=${P}/configs/ \
    file://luckfox-pico-plus-rv1106_defconfig;subdir=${P}/configs/ \
    file://luckfox-pico-max-rv1106_defconfig;subdir=${P}/configs/ \
"


# ---------------------------------------------------------------------------
# Saveable U-Boot environment (MACHINE_FEATURES += "rk-u-boot-env")
#
# meta-rockchip provides the config fragment, the userspace tools (via
# u-boot-fw-utils/u-boot-env) and the wks rawcopy hook, but its
# rk_generate_env() postfunc assumes a non-UBOOT_CONFIG build and looks for
# ${B}/.config. Every machine in this layer uses UBOOT_CONFIG, so the config
# lives in ${B}/<defconfig>-<type>/. Replace the postfunc with one that copes
# with both layouts.
# ---------------------------------------------------------------------------

rv110x_generate_env() {
    # With UBOOT_CONFIG the real .config is in the per-flavour build dir.
    local cfg
    cfg="$(ls ${B}/*/.config ${B}/.config 2>/dev/null | head -n 1)"
    if [ -z "${cfg}" ]; then
        echo "u-boot env: no .config found under ${B}, cannot determine CONFIG_ENV_SIZE"
        return 1
    fi

    local env_size
    env_size="$(sed -n 's/^CONFIG_ENV_SIZE=//p' "${cfg}" | head -n 1)"
    if [ -z "${env_size}" ]; then
        echo "u-boot env: CONFIG_ENV_SIZE not found in ${cfg}"
        return 1
    fi

    # Configuration for the Linux userspace tools (fw_printenv/fw_setenv).
    echo "/dev/disk/by-partlabel/uboot_env 0x0000 ${env_size}" > ${UNPACKDIR}/fw_env.config

    # Optionally seed the environment partition with the built-in environment.
    if [ "${@bb.utils.to_boolean(d.getVar('RK_IMAGE_INCLUDES_UBOOT_ENV'), False)}" = "True" ]; then
        local initial_env
        initial_env="$(ls ${B}/*/u-boot-initial-env ${B}/u-boot-initial-env 2>/dev/null | head -n 1)"
        if [ -z "${initial_env}" ]; then
            echo "u-boot env: u-boot-initial-env not found under ${B}"
            return 1
        fi
        mkenvimage -s "${env_size}" "${initial_env}" -o "${B}/u-boot.env"
    fi
}

do_compile[postfuncs] = "${@'rv110x_generate_env' if 'rk-u-boot-env' in d.getVar('MACHINEOVERRIDES').split(':') else ''}"
