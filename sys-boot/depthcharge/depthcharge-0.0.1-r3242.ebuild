# Copyright 2012 The Chromium OS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("5f47c4961d93d3cacd50aa933e54e65c21b8eefe" "029263c8be01430699553ddcf2631f7e37f2526c")
CROS_WORKON_TREE=("f57efd1badccfe0edb65dbc21c0fd3d86b6b7d68" "d6c0bd32b1fc591e407837a66183599c9de9b9c6")
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
CROS_WORKON_DESTDIR=("${S}/depthcharge" "${VBOOT_REFERENCE_DESTDIR}")

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
# Usage example: dc_make dev "${BUILD_DIR}" "${LIBPAYLOAD_DIR}"
# Args:
#   $1: Target to build
#   $2: Build directory to use.
#   $3: Directory where libpayload is located.
#   $4+: Any other Makefile arguments.
dc_make() {
	local target="$1"
	local builddir="$2"
	local libpayload="$3"

	shift 3

	local OPTS=(
		"EC_HEADERS=${SYSROOT}/usr/include/chromeos/ec"
		"VB_SOURCE=${VBOOT_REFERENCE_DESTDIR}"
		"PD_SYNC=$(usev pd_sync)"
		"LIBPAYLOAD_DIR=${libpayload}/libpayload"
		"obj=${builddir}"
	)

	use verbose && OPTS+=( "V=1" )
	use debug && OPTS+=( "SOURCE_DEBUG=1" )

	emake "${OPTS[@]}" \
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
#   $2: build directory
#   $3: libpayload dir
make_depthcharge() {
	local board="$1"
	local builddir="$2"
	local libpayload="$3"
	local base_defconfig="board/${board}/defconfig"
	local defconfig="${T}/${board}-defconfig"
	local config="${builddir}/depthcharge.config"

	if [[ -e "${base_defconfig}" ]]; then
		cp "${base_defconfig}" "${defconfig}"
	else
		ewarn "${base_defconfig} does not exist!"
		touch "${defconfig}"
	fi

	chmod +w "${defconfig}"

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

	dc_make defconfig "${builddir}" "${libpayload}" \
		KBUILD_DEFCONFIG="${defconfig}" \
		DOTCONFIG="${config}"

	dc_make depthcharge "${builddir}" "${libpayload}" \
		DOTCONFIG="${config}"
	dc_make dev "${builddir}" "${libpayload}.gdb" \
		DOTCONFIG="${config}"
	dc_make netboot "${builddir}" "${libpayload}.gdb" \
		DOTCONFIG="${config}"
}

# Copy the fwconfig from libpayload to a path
# Args:
#    $1: libpayload dir
#    $2: depthcharge build directory
_copy_fwconfig() {
	local src="${1}/libpayload/include/static_fw_config.h"
	local dest="${2}/static_fw_config.h"

	if [[ -s "${src}" ]]; then
		cp "${src}" "${dest}"
		einfo "Copying ${src} into local tree"
	else
		ewarn "${src} does not exist"
	fi
}

src_compile() {
	local builddir
	local libpayload

	# Firmware related binaries are compiled with a 32-bit toolchain
	# on 64-bit platforms
	if use amd64 ; then
		export CROSS_COMPILE="i686-pc-linux-gnu-"
		export CC="${CROSS_COMPILE}gcc"
	else
		export CROSS_COMPILE=${CHOST}-
	fi

	pushd depthcharge >/dev/null || \
		die "Failed to change into ${PWD}/depthcharge"

	if use unibuild; then
		local name
		local depthcharge

		while read -r name && read -r depthcharge; do
			libpayload="${SYSROOT}/firmware/${name}/libpayload"
			builddir="$(cros-workon_get_build_dir)/${depthcharge}"
			mkdir -p "${builddir}"

			_copy_fwconfig "${libpayload}" "${builddir}"
			make_depthcharge "${depthcharge}" "${builddir}" "${libpayload}"
		done < <(cros_config_host get-firmware-build-combinations depthcharge)
	else
		libpayload="${SYSROOT}/firmware/legacy/libpayload"
		builddir="$(cros-workon_get_build_dir)"
		mkdir -p "${builddir}"

		_copy_fwconfig "${libpayload}" "${builddir}"
		make_depthcharge "$(get_board)" "${builddir}" "${libpayload}"
	fi

	popd >/dev/null || die
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

	popd >/dev/null || die
}

src_install() {
	if use unibuild; then
		local build_target
		local builddir

		for build_target in $(cros_config_host \
				get-firmware-build-targets depthcharge); do
			builddir="$(cros-workon_get_build_dir)/${build_target}"

			do_install "${build_target}" "${builddir}"
		done
	else
		do_install "$(get_board)" "$(cros-workon_get_build_dir)"
	fi
}
