# Copyright 2012 The Chromium OS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("759d7b9b2d9b60108df27f159c23a644ee3ce7fd" "7eb8739a244b4b7f52ef7b14f2ce97ae9cec714b")
CROS_WORKON_TREE=("4c89034862d250152e79f28a26c736bccc68ad15" "fd3ccdacdcbd0c874cbb2132685c916bd4cd62c0")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/depthcharge"
	"chromiumos/platform/vboot_reference"
)

DESCRIPTION="coreboot's depthcharge payload"
HOMEPAGE="http://www.coreboot.org"
LICENSE="GPL-2"
KEYWORDS="*"
IUSE="detachable diag_payload fwconsole mocktpm pd_sync
	unibuild verbose debug generated_cros_config +minidiag
	physical_presence_power physical_presence_recovery"

DEPEND="
	sys-boot/coreboot:=
	chromeos-base/chromeos-ec-headers:=
	sys-boot/libpayload:=
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
"

BDEPEND="
	dev-python/kconfiglib
"

CROS_WORKON_LOCALNAME=("../platform/depthcharge" "../platform/vboot_reference")
VBOOT_REFERENCE_DESTDIR="${S}/vboot_reference"
CROS_WORKON_DESTDIR=("${S}" "${VBOOT_REFERENCE_DESTDIR}")

# Don't strip to ease remote GDB use (cbfstool strips final binaries anyway)
STRIP_MASK="*"

inherit cros-workon cros-board cros-unibuild

# Get the depthcharge board config to build for.
# Checks the current board with/without variant. Echoes the board config file
# that should be used to build depthcharge.
get_board() {
	local board=$(get_current_board_with_variant)
	if [[ ! -d "board/${board}" ]]; then
		board=$(get_current_board_no_variant)
	fi

	echo "${board}"
}

# Build depthcharge with common options.
# Usage example: dc_make dev LIBPAYLOAD_DIR="libpayload"
# Args:
#   $1: Target to build
#   $2: Build directory to use.
#   $3: Firmware file to use for LIBPAYLOAD_DIR
#   $4+: Any other Makefile arguments.
dc_make() {
	local target="$1"
	local builddir="$2"
	local libpayload

	[[ -n "$3" ]] && libpayload="LIBPAYLOAD_DIR=${SYSROOT}/firmware/$3/"

	shift 3

	local OPTS=(
		"EC_HEADERS=${SYSROOT}/usr/include/chromeos/ec"
		"VB_SOURCE=${VBOOT_REFERENCE_DESTDIR}"
		"PD_SYNC=$(usev pd_sync)"
		"obj=${builddir}"
	)

	use verbose && OPTS+=( "V=1" )
	use debug && OPTS+=( "SOURCE_DEBUG=1" )

	emake "${OPTS[@]}" \
		${libpayload} \
		"${target}" \
		"$@"
}

# Build depthcharge for the current board.
# Builds the various output files for depthcharge:
#   depthcharge.elf   - normal image
#   dev.elf           - developer image
#   netboot.elf       - network image
# In addition, .map files are produced for each, and a .config file which
# holds the configuration that was used.
# Args
#   $1: board to build for.
make_depthcharge() {
	local board="$1"
	local builddir="$2"
	local defconfig="board/${board}/defconfig"

	if use mocktpm ; then
		echo "CONFIG_MOCK_TPM=y" >> "${defconfig}"
	fi
	if use fwconsole ; then
		echo "CONFIG_CLI=y" >> "${defconfig}"
		echo "CONFIG_SYS_PROMPT=\"${board}: \"" >> "${defconfig}"
	fi
	if use detachable ; then
		echo "CONFIG_DETACHABLE=y" >> "${defconfig}"
	fi

	# Both diag_payload and minidiag need special UI.
	if use diag_payload || use minidiag ; then
		echo "CONFIG_DIAGNOSTIC_UI=y" >> "${defconfig}"
	fi

	if use physical_presence_power || use physical_presence_recovery ; then
		echo "CONFIG_PHYSICAL_PRESENCE_KEYBOARD=n" >> "${defconfig}"
	fi

	[[ ${PV} == "9999" ]] && dc_make distclean "${builddir}" libpayload
	dc_make defconfig "${builddir}" libpayload BOARD="${board}"
	cp .config "${builddir}/depthcharge.config"

	dc_make depthcharge "${builddir}" libpayload
	dc_make dev "${builddir}" libpayload_gdb
	dc_make netboot "${builddir}" libpayload_gdb
}

src_compile() {
	local from_root="${SYSROOT}/firmware/libpayload/include/"
	local to="src/base/static_fw_config.h"

	# Firmware related binaries are compiled with a 32-bit toolchain
	# on 64-bit platforms
	if use amd64 ; then
		export CROSS_COMPILE="i686-pc-linux-gnu-"
		export CC="${CROSS_COMPILE}gcc"
	else
		export CROSS_COMPILE=${CHOST}-
	fi

	if use unibuild; then
		local combinations="coreboot,depthcharge"
		local cmd="get-firmware-build-combinations"
		local build_combinations=$(cros_config_host "${cmd}" "${combinations}" || die)
		local build_target

		for build_target in $(cros_config_host \
			get-firmware-build-targets depthcharge); do
			# install the matching static_fw_config_${board}.h
			echo "${build_combinations}" | while read -r name; do
				read -r coreboot
				read -r depthcharge
				local from="${from_root}static_fw_config_${coreboot}.h"

				if [[ "${build_target}" == "${depthcharge}" ]] &&
						[[ -s "${from}" ]]; then
					cp "${from}" "${to}"
					einfo "Copying static_fw_config_${coreboot}.h into local tree"
					break
				fi
			done

			# build depthcharge
			make_depthcharge "${build_target}" "${build_target}"
		done
	else
		local from="${from_root}static_fw_config.h"
		if [[ -s "${from}" ]]; then
			cp "${from}" "${to}"
			einfo "Copying static_fw_config.h into local tree"
		fi
		make_depthcharge "$(get_board)" build
	fi
}

do_install() {
	local board="$1"
	local builddir="$2"
	local dstdir="/firmware"

	if [[ -n "${build_target}" ]]; then
		dstdir+="/${build_target}"
		einfo "Installing depthcharge ${build_target} into ${dest_dir}"
	fi
	insinto "${dstdir}"

	pushd "${builddir}" >/dev/null || \
		die "couldn't access ${builddir}/ directory"

	local files_to_copy=(
		depthcharge.config
		{netboot,depthcharge,dev}.elf{,.map}
	)

	insinto "${dstdir}/depthcharge"
	doins "${files_to_copy[@]}"

	popd >/dev/null
}

src_install() {
	local build_target

	if use unibuild; then
		for build_target in $(cros_config_host \
			get-firmware-build-targets depthcharge); do
			do_install "${build_target}" "${build_target}"
		done
	else
		do_install "$(get_board)" build
	fi
}
