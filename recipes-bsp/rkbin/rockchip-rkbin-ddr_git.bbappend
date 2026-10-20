
# Base recipe only supports rk3308/rk3566/rk3568/rk3588s
# Add support for RV1103/RV1106 and Luckfox machines
COMPATIBLE_MACHINE = "(luckfox-pico(-plus|-max|-mini|-pi)?-(sd-card|spi-nand)|rv1103|rv1106)"

DDRBIN_VERS_rv1106 ?= "v1.15"
DDRBIN_FILE_rv1106 ?= "rv1106_ddr_924MHz_${DDRBIN_VERS_rv1106}.bin"
DDRBIN_DEPLOY_FILENAME_rv1106 ?= "ddr-rv1106.bin"

DDRBIN_VERS_rv1103 ?= "v1.15"
DDRBIN_FILE_rv1103 ?= "rv1106_ddr_924MHz_${DDRBIN_VERS_rv1103}.bin"
DDRBIN_DEPLOY_FILENAME_rv1103 ?= "ddr-rv1103.bin"

do_deploy[vardeps] += "SOC_FAMILY"
do_deploy() {
    if [ "${SOC_FAMILY}" = "rv1103" ]; then
        install -d ${DEPLOYDIR}
        install -m 644 ${S}/bin/rv11/${DDRBIN_FILE_rv1103} ${DEPLOYDIR}/${DDRBIN_DEPLOY_FILENAME_rv1103}
    elif [ "${SOC_FAMILY}" = "rv1106" ]; then
        install -d ${DEPLOYDIR}
        install -m 644 ${S}/bin/rv11/${DDRBIN_FILE_rv1106} ${DEPLOYDIR}/${DDRBIN_DEPLOY_FILENAME_rv1106}
    fi
}
