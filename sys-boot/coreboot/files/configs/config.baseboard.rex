CONFIG_PAYLOAD_NONE=y
CONFIG_USE_BLOBS=y

# Chrome OS
CONFIG_CHROMEOS=y

# SPI Descriptor
CONFIG_HAVE_IFD_BIN=y

# FSP Blobs
CONFIG_ADD_FSP_BINARIES=y
CONFIG_FSP_M_FILE="3rdparty/blobs/intel/mtl/fsp/fspm.bin"
CONFIG_FSP_S_FILE="3rdparty/blobs/intel/mtl/fsp/fsps.bin"
CONFIG_RUN_FSP_GOP=y

# Management Engine
CONFIG_HAVE_ME_BIN=y
# CONFIG_STITCH_ME_BIN=y
# CONFIG_CSE_COMPONENTS_PATH="3rdparty/blobs/mainboard/google/brya/cse_inputs"
# CONFIG_CSE_FPT_FILE="qs_inputs/csme.bin"
# CONFIG_CSE_PMCP_FILE="qs_inputs/pmc.bin"
# CONFIG_CSE_IOMP_FILE="qs_inputs/iom.bin"
# CONFIG_CSE_TBTP_FILE="qs_inputs/tbt.bin"
# CONFIG_CSE_NPHY_FILE="qs_inputs/nphy.bin"
# CONFIG_CSE_PCHC_FILE="qs_inputs/pchc.bin"
# CONFIG_CSE_IUNP_FILE="qs_inputs/iunit.bin"
# CONFIG_CSE_OEMP_FILE="oem_km.bin"

# Microcode
CONFIG_CPU_MICROCODE_CBFS_EXTERNAL_BINS=y

# Video Blob
CONFIG_INTEL_GMA_ADD_VBT=y

# Serial console disabled by default (do not remove)
# CONFIG_CONSOLE_SERIAL is not set

# Event Logging
CONFIG_ELOG_GSMI=y
CONFIG_ELOG_BOOT_COUNT=y
CONFIG_ELOG_BOOT_COUNT_CMOS_OFFSET=144
CONFIG_SPI_FLASH_SMM=y

# Management Engine FW update
CONFIG_SOC_INTEL_CSE_RW_UPDATE=y
CONFIG_SOC_INTEL_CSE_RW_VERSION="18.0.0.7328"

# FILEPATH is set to blank to prevent any default SAR file from getting added.
CONFIG_WIFI_SAR_CBFS_FILEPATH="
