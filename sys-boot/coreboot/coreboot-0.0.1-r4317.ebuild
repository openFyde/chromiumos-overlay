# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Change this version number when any change is made to configs/files under
# coreboot and an auto-revbump is required.
# VERSION=REVBUMP-0.0.70

EAPI=7
CROS_WORKON_COMMIT=("b5f1fcee118ebceedd380cae55650c3aa3b71c60" "2c62b00e8c4b327165a4bfd874714aa460f3e176" "70838cc1a1294f1f53d00c08d3ee7616db073e8e" "6875b43ee0e1bec49862cc308967fd0cd8e949b3" "07b6961cd5b96d1d5d6b304f8009449e72a4b38d" "ee319ae7bc59e88b60142f40a9ec1b46656de4db" "b7d5b2d6a6dd05874d86ee900ff441d261f9034c")
CROS_WORKON_TREE=("028fce082cd55fa7ea4da50500cf1ddf07274c59" "710fd012fa3777c0457c122cc3d1d2f338c92f2c" "540f64491237d9a9fde2d43e51a175d906897bc9" "d107cdeaa4c26bc6acbe3358467a99f4754c7534" "7fd139e39bf0a32901f2f61d7569ec6bb0680c5d" "45d22a8711f85c4310c0c2121d3dc8a72793d375" "c0433b88f972fa26dded401be022c1c026cd644e")
CROS_WORKON_PROJECT=(
	"chromiumos/third_party/coreboot"
	"chromiumos/third_party/arm-trusted-firmware"
	"chromiumos/platform/vboot_reference"
	"chromiumos/third_party/coreboot/amd_blobs"
	"chromiumos/third_party/coreboot/blobs"
	"chromiumos/third_party/coreboot/intel-microcode"
	"chromiumos/third_party/cbootimage"
)
CROS_WORKON_LOCALNAME=(
	"coreboot"
	"arm-trusted-firmware"
	"../platform/vboot_reference"
	"coreboot/3rdparty/amd_blobs"
	"coreboot/3rdparty/blobs"
	"coreboot/3rdparty/intel-microcode"
	"cbootimage"
)
CROS_WORKON_DESTDIR=(
	"${S}"
	"${S}/3rdparty/arm-trusted-firmware"
	"${S}/3rdparty/vboot"
	"${S}/3rdparty/amd_blobs"
	"${S}/3rdparty/blobs"
	"${S}/3rdparty/intel-microcode"
	"${S}/util/nvidia/cbootimage"
)

CROS_WORKON_EGIT_BRANCH=(
	"chromeos-2016.05"
	"master"
	"master"
	"chromeos"
	"master"
	"master"
	"master"
)

inherit cros-board cros-workon toolchain-funcs cros-unibuild coreboot-sdk

DESCRIPTION="coreboot firmware"
HOMEPAGE="http://www.coreboot.org"
LICENSE="GPL-2"
KEYWORDS="*"
IUSE="em100-mode fsp memmaps mocktpm quiet-cb rmt vmx mtc mma"
IUSE="${IUSE} +bmpblk +intel_mrc qca-framework quiet unibuild verbose"
IUSE="${IUSE} amd_cpu coreboot-sdk chipset_stoneyridge chipset_picasso"
IUSE="${IUSE} chipset_cezanne generated_cros_config"
# virtual/coreboot-private-files is deprecated. When adding a new board you
# should add the coreboot-private-files-{board/chipset} ebuilds into the private
# overlays, and avoid creating virtual packages.
# See b/178642474
IUSE="${IUSE} coreboot-private-files-board coreboot-private-files-chipset"
# coreboot's build system handles stripping the binaries and producing a
# separate .debug file with the symbols. This flag prevents portage from
# stripping the .debug symbols
RESTRICT="strip"

RDEPEND=""
DEPEND="
	mtc? ( sys-boot/mtc:= )
	coreboot-private-files-board? ( sys-boot/coreboot-private-files-board:= )
	coreboot-private-files-chipset? ( sys-boot/coreboot-private-files-chipset:= )
	virtual/coreboot-private-files
	bmpblk? ( sys-boot/chromeos-bmpblk:= )
	intel_mrc? ( x86? ( sys-boot/chromeos-mrc:= )
		amd64? ( sys-boot/chromeos-mrc:= ) )
	chipset_stoneyridge? ( sys-boot/amd-firmware:= )
	chipset_picasso? ( >=sys-boot/amd-picasso-fsp-0.0.2:= )
	chipset_cezanne? ( sys-boot/amd-cezanne-fsp:= )
	qca-framework? ( sys-boot/qca-framework:= )
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
	"

# Get the coreboot board config to build for.
# Checks the current board with/without variant, and also whether an FSP
# is in use. Echoes the board config file that should be used to build
# coreboot.
get_board() {
	local board=$(get_current_board_with_variant)

	if [[ ! -s "${FILESDIR}/configs/config.${board}" ]]; then
		board=$(get_current_board_no_variant)
	fi
	echo "${board}"
}

set_build_env() {
	local board="$1"

	CONFIG="$(cros-workon_get_build_dir)/${board}.config"
	CONFIG_SERIAL="$(cros-workon_get_build_dir)/${board}-serial.config"
	# Strip the .config suffix
	BUILD_DIR="${CONFIG%.config}"
	BUILD_DIR_SERIAL="${CONFIG_SERIAL%.config}"
}

# Create the coreboot configuration files for a particular board. This
# creates a standard config and a serial config.
# Args:
#   $1: board name
#   $2: Base board name, if any (used for unified builds)
create_config() {
	local board="$1"
	local base_board="$2"

	if [[ -s "${FILESDIR}/configs/config.${board}" ]]; then

		cp -v "${FILESDIR}/configs/config.${board}" "${CONFIG}"
		# handle the case when "${CONFIG}" does not have a newline in the end.
		echo >> "${CONFIG}"

		# Override mainboard vendor if needed.
		if [[ -n "${SYSTEM_OEM}" ]]; then
			echo "CONFIG_MAINBOARD_VENDOR=\"${SYSTEM_OEM}\"" >> "${CONFIG}"
		fi
		if [[ -n "${SYSTEM_OEM_VENDOR_ID}" ]]; then
			echo "CONFIG_SUBSYSTEM_VENDOR_ID=${SYSTEM_OEM_VENDOR_ID}" >> "${CONFIG}"
		fi
		if [[ -n "${SYSTEM_OEM_DEVICE_ID}" ]]; then
			echo "CONFIG_SUBSYSTEM_DEVICE_ID=${SYSTEM_OEM_DEVICE_ID}" >> "${CONFIG}"
		fi
		if [[ -n "${SYSTEM_OEM_ACPI_ID}" ]]; then
			echo "CONFIG_ACPI_SUBSYSTEM_ID=\"${SYSTEM_OEM_ACPI_ID}\"" >> "${CONFIG}"
		fi

		# In case config comes from a symlink we are likely building
		# for an overlay not matching this config name. Enable adding
		# a CBFS based board ID for coreboot.
		if [[ -L "${FILESDIR}/configs/config.${board}" ]]; then
			echo "CONFIG_BOARD_ID_MANUAL=y" >> "${CONFIG}"
			echo "CONFIG_BOARD_ID_STRING=\"${BOARD_USE}\"" >> "${CONFIG}"
		fi
	else
		ewarn "Could not find existing config for ${board}."
	fi

	if use rmt; then
		echo "CONFIG_MRC_RMT=y" >> "${CONFIG}"
	fi
	if use vmx; then
		elog "   - enabling VMX"
		echo "CONFIG_ENABLE_VMX=y" >> "${CONFIG}"
	fi
	if use quiet-cb; then
		# Suppress console spew if requested.
		cat >> "${CONFIG}" <<EOF
CONFIG_DEFAULT_CONSOLE_LOGLEVEL=3
# CONFIG_DEFAULT_CONSOLE_LOGLEVEL_8 is not set
CONFIG_DEFAULT_CONSOLE_LOGLEVEL_3=y
EOF
	fi
	if use mocktpm; then
		echo "CONFIG_VBOOT_MOCK_SECDATA=y" >> "${CONFIG}"
	fi
	if use mma; then
		echo "CONFIG_MMA=y" >> "${CONFIG}"
	fi

	# disable coreboot's own EC firmware building mechanism
	echo "CONFIG_EC_GOOGLE_CHROMEEC_FIRMWARE_NONE=y" >> "${CONFIG}"
	echo "CONFIG_EC_GOOGLE_CHROMEEC_PD_FIRMWARE_NONE=y" >> "${CONFIG}"
	# enable common GBB flags for development
	echo "CONFIG_GBB_FLAG_DEV_SCREEN_SHORT_DELAY=y" >> "${CONFIG}"
	echo "CONFIG_GBB_FLAG_DISABLE_FW_ROLLBACK_CHECK=y" >> "${CONFIG}"
	echo "CONFIG_GBB_FLAG_FORCE_DEV_BOOT_USB=y" >> "${CONFIG}"
	echo "CONFIG_GBB_FLAG_FORCE_DEV_SWITCH_ON=y" >> "${CONFIG}"
	local version=$(${CHROOT_SOURCE_ROOT}/src/third_party/chromiumos-overlay/chromeos/config/chromeos_version.sh |grep "^[[:space:]]*CHROMEOS_VERSION_STRING=" |cut -d= -f2)
	echo "CONFIG_VBOOT_FWID_VERSION=\".${version}\"" >> "${CONFIG}"
	if use em100-mode; then
		einfo "Enabling em100 mode via CONFIG_EM100 (slower SPI flash)"
		echo "CONFIG_EM100=y" >> "${CONFIG}"
	fi
	# Use FSP's GOP in favor of coreboot's Ada based Intel graphics init
	# which we don't include at this time. A no-op on non-FSP/GOP devices.
	echo "CONFIG_RUN_FSP_GOP=y" >> "${CONFIG}"

	cp "${CONFIG}" "${CONFIG_SERIAL}"
	file="${FILESDIR}/configs/fwserial.${board}"
	if [ ! -f "${file}" ] && [ -n "${base_board}" ]; then
		file="${FILESDIR}/configs/fwserial.${base_board}"
	fi
	if [ ! -f "${file}" ]; then
		file="${FILESDIR}/configs/fwserial.default"
	fi
	cat "${file}" >> "${CONFIG_SERIAL}" || die
	# handle the case when "${CONFIG_SERIAL}" does not have a newline in the end.
	echo >> "${CONFIG_SERIAL}"

	# Check that we're using coreboot-sdk
	if ! use coreboot-sdk; then
		die "Enable coreboot-sdk to build coreboot."
	fi
	if grep -q "^CONFIG_ANY_TOOLCHAIN=y" "${CONFIG}"; then
		die "Drop ANY_TOOLCHAIN from ${CONFIG}: we don't support it anymore."
	fi

	einfo "Configured ${CONFIG} for board ${board} in ${BUILD_DIR}"
}

src_prepare() {
	local froot="${SYSROOT}/firmware"
	local privdir="${SYSROOT}/firmware/coreboot-private"
	local file

	default

	mkdir "$(cros-workon_get_build_dir)"

	if [[ -d "${privdir}" ]]; then
		while read -d $'\0' -r file; do
			rsync --recursive --links --executability \
				"${file}" ./ || die
		done < <(find "${privdir}" -maxdepth 1 -mindepth 1 -print0)
	fi

	for blob in mrc.bin mrc.elf efi.elf; do
		if [[ -r "${SYSROOT}/firmware/${blob}" ]]; then
			cp "${SYSROOT}/firmware/${blob}" 3rdparty/blobs/
		fi
	done

	cp -a "${FILESDIR}/3rdparty/"* 3rdparty

	if use unibuild; then
		local build_target

		while read -r name; do
			read -r coreboot
			set_build_env "${coreboot}"
			create_config "${coreboot}" "$(get_board)"
		done < <(cros_config_host "get-firmware-build-combinations" coreboot || die)
	else
		set_build_env "$(get_board)"
		create_config "$(get_board)"
	fi
}

add_fw_blob() {
	local rom="$1"
	local cbname="$2"
	local blob="$3"
	local cbhash="${cbname%.bin}.hash"
	local hash="${blob%.bin}.hash"

	cbfstool "${rom}" add -r FW_MAIN_A,FW_MAIN_B -t raw -c lzma \
		-f "${blob}" -n "${cbname}" || die
	cbfstool "${rom}" add -r FW_MAIN_A,FW_MAIN_B -t raw -c none \
		-f "${hash}" -n "${cbhash}" || die
}

# Build coreboot with a supplied configuration and output directory.
#   $1: Build directory to use (e.g. "build_serial")
#   $2: Config file to use (e.g. ".config_serial")
#   $3: Build target build (e.g. "pyro"), for USE=unibuild only.
make_coreboot() {
	local builddir="$1"
	local config_fname="$2"

	rm -rf "${builddir}" .xcompile

	local CB_OPTS=( "DOTCONFIG=${config_fname}" )
	use quiet && CB_OPTS+=( "V=0" )
	use verbose && CB_OPTS+=( "V=1" )
	use quiet && REDIR="/dev/null" || REDIR="/dev/stdout"

	# Configure and build coreboot.
	yes "" | emake oldconfig "${CB_OPTS[@]}" obj="${builddir}" >${REDIR}
	if grep -q "CONFIG_VENDOR_EMULATION=y" "${config_fname}"; then
		local config_file
		config_file="${FILESDIR}/configs/config.$(get_board)"
		die "Working with a default configuration. ${config_file} incorrect?"
	fi
	emake "${CB_OPTS[@]}" obj="${builddir}" HOSTCC="$(tc-getBUILD_CC)" \
		HOSTPKGCONFIG="$(tc-getBUILD_PKG_CONFIG)"

	# Expand FW_MAIN_* since we might add some files
	cbfstool "${builddir}/coreboot.rom" expand -r FW_MAIN_A,FW_MAIN_B

	# Modify firmware descriptor if building for the EM100 emulator on
	# Intel platforms.
	# TODO(crbug.com/863396): Should we have an 'intel' USE flag? Do we
	# still have any Intel platforms that don't use ifdtool?
	if ! use amd_cpu && use em100-mode; then
		einfo "Enabling em100 mode via ifdttool (slower SPI flash)"
		ifdtool --em100 "${builddir}/coreboot.rom" || die
		mv "${builddir}/coreboot.rom"{.new,} || die
	fi
}

# Add fw blobs to the coreboot.rom.
#   $1: Build directory to use (e.g. "build_serial")
#   $2: Build target build (e.g. "pyro"), for USE=unibuild only.
add_fw_blobs() {
	local builddir="$1"
	local build_target="$2"
	local froot="${SYSROOT}/firmware"
	local fblobroot="${SYSROOT}/firmware"

	if use unibuild; then
		froot+="/${build_target}"
	fi

	local blob
	local cbname
	for blob in ${FW_BLOBS}; do
		local blobfile="${fblobroot}/${blob}"

		# Use per-board blob if available
		if use unibuild && [[ -e "${froot}/${blob}" ]]; then
			blobfile="${froot}/${blob}"
		fi

		cbname=$(basename "${blob}")
		add_fw_blob "${builddir}/coreboot.rom" "${cbname}" \
			"${blobfile}" || die
	done

	if [ -d ${froot}/cbfs ]; then
		die "something is still using ${froot}/cbfs, which is deprecated."
	fi
}

src_compile() {
	# Set KERNELREVISION (really coreboot revision) to the ebuild revision
	# number followed by a dot and the first seven characters of the git
	# hash. The name is confusing but consistent with the coreboot
	# Makefile.
	local sha1v="${VCSID/*-/}"
	export KERNELREVISION=".${PV}.${sha1v:0:7}"

	if ! use coreboot-sdk; then
		tc-export CC
		# Export the known cross compilers so there isn't a reliance
		# on what the default profile is for exporting a compiler. The
		# reasoning is that the firmware may need more than one to build
		# and boot.
		export CROSS_COMPILE_x86="i686-pc-linux-gnu-"
		export CROSS_COMPILE_mipsel="mipsel-cros-linux-gnu-"
		export CROSS_COMPILE_arm64="aarch64-cros-linux-gnu-"
		export CROSS_COMPILE_arm="armv7a-cros-linux-gnu- armv7a-cros-linux-gnueabihf-"
	else
		export CROSS_COMPILE_x86=${COREBOOT_SDK_PREFIX_x86_32}
		export CROSS_COMPILE_mipsel=${COREBOOT_SDK_PREFIX_mips}
		export CROSS_COMPILE_arm64=${COREBOOT_SDK_PREFIX_arm64}
		export CROSS_COMPILE_arm=${COREBOOT_SDK_PREFIX_arm}

		export PATH=/opt/coreboot-sdk/bin:$PATH
	fi

	use verbose && elog "Toolchain:\n$(sh util/xcompile/xcompile)\n"

	if use unibuild; then
		while read -r name; do
			read -r coreboot

			set_build_env "${coreboot}"
			make_coreboot "${BUILD_DIR}" "${CONFIG}"
			add_fw_blobs "${BUILD_DIR}" "${coreboot}"

			# Build a second ROM with serial support for developers.
			make_coreboot "${BUILD_DIR_SERIAL}" "${CONFIG_SERIAL}"
			add_fw_blobs "${BUILD_DIR_SERIAL}" "${coreboot}"
		done < <(cros_config_host "get-firmware-build-combinations" coreboot || die)
	else
		set_build_env "$(get_board)"
		make_coreboot "${BUILD_DIR}" "${CONFIG}"
		add_fw_blobs "${BUILD_DIR}"

		# Build a second ROM with serial support for developers.
		make_coreboot "${BUILD_DIR_SERIAL}" "${CONFIG_SERIAL}"
		add_fw_blobs "${BUILD_DIR_SERIAL}"
	fi
}

do_install() {
	local build_target="$1"
	local dest_dir="/firmware"
	local mapfile

	if [[ -n "${build_target}" ]]; then
		dest_dir+="/${build_target}"
		einfo "Installing coreboot ${build_target} into ${dest_dir}"
	fi
	insinto "${dest_dir}"

	newins "${BUILD_DIR}/coreboot.rom" coreboot.rom
	newins "${BUILD_DIR_SERIAL}/coreboot.rom" coreboot.rom.serial

	OPROM=$( awk 'BEGIN{FS="\""} /CONFIG_VGA_BIOS_FILE=/ { print $2 }' \
		"${CONFIG}" )
	CBFSOPROM=pci$( awk 'BEGIN{FS="\""} /CONFIG_VGA_BIOS_ID=/ { print $2 }' \
		"${CONFIG}" ).rom
	FSP=$( awk 'BEGIN{FS="\""} /CONFIG_FSP_FILE=/ { print $2 }' \
		"${CONFIG}" )
	if [[ -n "${FSP}" ]]; then
		newins ${FSP} fsp.bin
	fi
	# Save the psp_verstage binary for signing on AMD Fam17h platforms
	if [[ -e "${BUILD_DIR}/psp_verstage.bin" ]]; then
		newins "${BUILD_DIR}/psp_verstage.bin" psp_verstage.bin
	fi
	if [[ -n "${OPROM}" ]]; then
		newins ${OPROM} ${CBFSOPROM}
	fi
	if use memmaps; then
		for mapfile in "${BUILD_DIR}"/cbfs/fallback/*.map
		do
			doins $mapfile
		done
	fi
	newins "${CONFIG}" coreboot.config
	newins "${CONFIG_SERIAL}" coreboot_serial.config

	# Keep binaries with debug symbols around for crash dump analysis
	if [[ -s "${BUILD_DIR}/bl31.elf" ]]; then
		newins "${BUILD_DIR}/bl31.elf" bl31.elf
		newins "${BUILD_DIR_SERIAL}/bl31.elf" bl31.serial.elf
	fi
	insinto "${dest_dir}"/coreboot
	doins "${BUILD_DIR}"/cbfs/fallback/*.debug
	nonfatal doins "${BUILD_DIR}"/cbfs/fallback/bootblock.bin
	insinto "${dest_dir}"/coreboot_serial
	doins "${BUILD_DIR_SERIAL}"/cbfs/fallback/*.debug
	nonfatal doins "${BUILD_DIR_SERIAL}"/cbfs/fallback/bootblock.bin

	# coreboot's static_fw_config.h is copied into
	# /firmware/libpayload/include in order for other firmware to consume
	# the FW_CONFIG decoder macros. For unibuild, it is renamed to include
	# the build target.
	insinto "/firmware/libpayload/include"
	if use unibuild; then
		newins "${BUILD_DIR}"/static_fw_config.h "static_fw_config_${build_target}.h"
	else
		doins "${BUILD_DIR}"/static_fw_config.h
	fi
	einfo "Installed static_fw_config.h into /firmware/libpayload/include"
}

src_install() {
	if use unibuild; then
		while read -r name; do
			read -r coreboot

			set_build_env "${coreboot}"
			do_install "${coreboot}"
		done < <(cros_config_host "get-firmware-build-combinations" coreboot || die)
	else
		set_build_env "$(get_board)"
		do_install
	fi
}
