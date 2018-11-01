# Copyright (C) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

# A note about this ebuild: this ebuild is Unified Build enabled but
# not in the way in which most other ebuilds with Unified Build
# knowledge are: the primary use for this ebuild is for engineer-local
# work or firmware builder work. In both cases, the build might be
# happening on a branch in which only one of many of the models are
# available to build. The logic in this ebuild succeeds so long as one
# of the many models successfully builds.

EAPI="5"

CROS_WORKON_COMMIT=("cad8fea56739f0050272426b7481db79cae07d73" "f6a820be22639509e49c3184d724cada892e6245" "6283eeeaf5ccebcca982d5318b36d49e7b32cb6d")
CROS_WORKON_TREE=("685769b726c6a10c11893f3fcfb4463611d201ef" "7563bbafbdfaa90231e8390fd48e2b57f7e8848f" "cc44d33412e29b2c10a03bf8ac819f5630af57b2")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/tpm2"
	"chromiumos/third_party/cryptoc"
)
CROS_WORKON_LOCALNAME=(
	"ec"
	"../third_party/tpm2"
	"../third_party/cryptoc"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/tpm2"
	"${S}/third_party/cryptoc"
)

inherit toolchain-funcs cros-ec-board cros-workon cros-unibuild coreboot-sdk

DESCRIPTION="Embedded Controller firmware code"
HOMEPAGE="https://www.chromium.org/chromium-os/ec-development"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="quiet verbose coreboot-sdk unibuild fuzzer bootblock_in_ec"

RDEPEND="
	dev-embedded/libftdi
	fuzzer? (
		dev-libs/openssl:=
		dev-libs/protobuf:=
	)
"
DEPEND="
	${RDEPEND}
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
	virtual/chromeos-ec-private-files
	virtual/chromeos-ec-touch-firmware
	unibuild? ( chromeos-base/chromeos-config )
	bootblock_in_ec? ( sys-boot/coreboot )
"

# We don't want binchecks since we're cross-compiling firmware images using
# non-standard layout.
RESTRICT="binchecks"

src_unpack() {
	cros-workon_src_unpack
	S+="/platform/ec"
}

src_prepare() {
	if ! [[ ${PV} = 9999* ]]; then
		# Link the private sources in the private/ sub-directory if needed
		ln -sf ${SYSROOT}/firmware/ec-private ${S}/private
	fi
}

src_configure() {
	cros-workon_src_configure
}

set_build_env() {
	if ! use coreboot-sdk; then
		export CROSS_COMPILE_arm=arm-none-eabi-
		export CROSS_COMPILE_i386=i686-pc-linux-gnu-
	else
		export CROSS_COMPILE_arm=${COREBOOT_SDK_PREFIX_arm}
		export CROSS_COMPILE_i386=${COREBOOT_SDK_PREFIX_x86_32}
	fi

	export CROSS_COMPILE_coreboot_sdk_arm=${COREBOOT_SDK_PREFIX_arm}
	export CROSS_COMPILE_coreboot_sdk_i386=${COREBOOT_SDK_PREFIX_x86_32}

	# nds32 always uses coreboot-sdk
	export CROSS_COMPILE_nds32=${COREBOOT_SDK_PREFIX_nds32}

	tc-export CC BUILD_CC
	export HOSTCC=${CC}
	export BUILDCC=${BUILD_CC}

	get_ec_boards

	EC_OPTS=()
	use quiet && EC_OPTS+=( -s V=0 )
	use verbose && EC_OPTS+=( V=1 )
}

# Build EC with a supplied configuration and output directory.
#   $1: Board name.
#   $2: Build directory to use (e.g. "build_serial").
#   $3: Path to touchpad firmware to be packed (optional).
#   $4: Path to bootblock to be packed (optional).
make_ec() {
	local board="$1"
	local build_dir="$2"
	local touchpad_fw="$3"
	local bootblock="$4"
	local extra_opts=()

	einfo "Building EC for ${board} into ${build_dir} with" \
		"touchpad_fw=${touchpad_fw} bootblock=${bootblock}"

	if [[ -n "${touchpad_fw}" ]]; then
		extra_opts+=( TOUCHPAD_FW="${touchpad_fw}" )
	fi
	if [[ -n "${bootblock}" ]]; then
		if [[ ! -f "${bootblock}" ]]; then
			die "bootblock file not available: ${bootblock}"
		fi
		extra_opts+=( BOOTBLOCK="${bootblock}" )
	fi

	BOARD=${target} emake "${EC_OPTS[@]}" clean
	BOARD=${target} emake "${EC_OPTS[@]}" "${extra_opts[@]}" all
	BOARD=${target} emake "${EC_OPTS[@]}" tests
	# Since the ec codebase does not allow specifying a target build
	# directory, move its build directory to the requested location.
	rm -rf "${build_dir}"
	mv build "${build_dir}"
}

src_compile() {
	set_build_env

	local target
	einfo "Building targets: ${EC_BOARDS[@]}"
	for target in "${EC_BOARDS[@]}"; do
		# Always pass TOUCHPAD_FW parameter: boards that do not require
		# it will simply ignore the parameter, even if the touchpad FW
		# file does not exist.  Note that touchpad firmware lives in
		# the ${target} subdirectory regardless of whether or not unibuild
		# is enabled.
		local touchpad_fw="${SYSROOT}/firmware/${target}/touchpad.bin"

		# In certain devices, the only root-of-trust available is EC-RO.
		# Thus the AP bootblock needs to be installed in this write-protected
		# area, and supplied to AP on boot.  See b:110907438 for details.
		local bootblock
		local bootblock_serial
		local target_root
		if use unibuild; then
			target_root="${SYSROOT}/firmware/${target}"
		else
			target_root="${SYSROOT}/firmware"
		fi

		if use bootblock_in_ec; then
			local bootblock="${target_root}/coreboot/bootblock.bin"
			local bootblock_serial="${target_root}/coreboot_serial/bootblock.bin"

			# Since we are including AP bootblock, two sets of EC images need to
			# be built -- one with serial console enabled, and one without.
			make_ec "${target}" "${WORKDIR}/build_${target}_serial" \
				"${touchpad_fw}" "${bootblock_serial}"
		fi
		make_ec "${target}" "${WORKDIR}/build_${target}" \
			"${touchpad_fw}" "${bootblock}"
	done

	if use fuzzer ; then
		emake buildfuzztests
	fi
}

#
# Install firmware binaries for a specific board.
#
# param $1 - the board name.
# param $2 - the build directory.
# param $3 - the output directory to install artifacts.
# param $4 - the suffix to be used for installed artifacts (optional).
#            e.g. if suffix="serial", ec.bin => ec.serial.bin
#
board_install() {
	local board="$1"
	local build_dir="$2"
	local dest_dir="$3"
	local suffix="$4"
	local file_suffix
	local ecrw

	einfo "Installing EC for ${board} from ${build_dir} into ${dest_dir}" \
		"(suffix=${suffix})"

	if [[ -n "${suffix}" ]]; then
		file_suffix=".${suffix}"
	fi

	insinto "${dest_dir}"
	pushd "${build_dir}/${target}" >/dev/null || die

	openssl dgst -sha256 -binary RO/ec.RO.flat > RO/ec.RO.hash
	newins ec.bin "ec${file_suffix}.bin"
	if grep -q '^CONFIG_VBOOT_EFS=y' .config; then
		# This extracts EC_RW.bin (= RW_A region image) from ec.bin.
		futility sign --type rwsig ec.bin || die
		ecrw="EC_RW.bin"
	else
		ecrw="RW/ec.RW.flat"
	fi
	newins "${ecrw}" "ec${file_suffix}.RW.bin"
	openssl dgst -sha256 -binary "${ecrw}" > RW/ec.RW.hash
	newins RW/ec.RW.hash "ec${file_suffix}.RW.hash"
	# Intermediate file for debugging.
	newins RW/ec.RW.elf "ec${file_suffix}.RW.elf"

	# Install RW_B files except for RWSIG, which uses the same files as RW_A
	if grep -q '^CONFIG_RW_B=y' .config && \
			! grep -q '^CONFIG_RWSIG_TYPE_RWSIG=y' .config; then
		openssl dgst -sha256 -binary RW/ec.RW_B.flat > RW/ec.RW_B.hash
		newins RW/ec.RW_B.flat "ec${file_suffix}.RW_B.bin"
		newins RW/ec.RW_B.hash "ec${file_suffix}.RW_B.hash"
		# Intermediate file for debugging.
		newins RW/ec.RW_B.elf "ec${file_suffix}.RW_B.elf"
	fi

	if grep -q '^CONFIG_FW_INCLUDE_RO=y' .config; then
		newins RO/ec.RO.flat "ec${file_suffix}.RO.bin"
		newins RO/ec.RO.hash "ec${file_suffix}.RO.hash"
		# Intermediate file for debugging.
		newins RO/ec.RO.elf "ec${file_suffix}.RO.elf"
	fi

	# The shared objects library is not built by default.
	if grep -q '^CONFIG_SHAREDLIB=y' .config; then
		newins libsharedobjs/libsharedobjs.elf "libsharedobjs${file_suffix}.elf"
	fi

	if [[ -f chip/npcx/spiflashfw/npcx_monitor.bin ]]; then
		doins chip/npcx/spiflashfw/npcx_monitor.bin
	fi

	# EC test binaries
	stat -t test-*.bin >/dev/null || ewarn "No test binaries found"
	for f in test-*.bin; do
		local name="${f%.bin}"
		nonfatal newins "${f}" "${name}${file_suffix}.bin"
	done
	popd > /dev/null
}

src_install() {
	set_build_env

	local target

	einfo "Installing targets: ${EC_BOARDS[@]}"
	for target in "${EC_BOARDS[@]}"; do
		board_install "${target}" "${WORKDIR}/build_${target}" \
			"/firmware/${target}" "" \
			|| die "Couldn't install ${target}"
		if use bootblock_in_ec; then
			board_install "${target}" "${WORKDIR}/build_${target}_serial" \
				"/firmware/${target}" serial \
				|| die "Couldn't install ${target} (serial)"
		fi
	done
	# Unibuild platforms don't have "main" EC firmware.
	if ! use unibuild; then
		target="${EC_BOARDS[0]}"
		board_install "${target}" "${WORKDIR}/build_${target}" \
			/firmware "" \
			|| die "Couldn't install main firmware"
		if use bootblock_in_ec; then
			board_install "${target}" "${WORKDIR}/build_${target}_serial" \
				/firmware serial \
				|| die "Couldn't install main firmware"
		fi
	fi

	if use fuzzer ; then
		local f

		insinto /usr/libexec/fuzzers
		exeinto /usr/libexec/fuzzers
		for f in build/host/*_fuzz/*_fuzz.exe; do
			local fuzzer="$(basename "${f}")"
			fuzzer="ec_${fuzzer%_fuzz.exe}_fuzzer"
			newexe "${f}" "${fuzzer}"
			newins "${S}/OWNERS" "${f##*/}.owners"
		done
	fi
}

src_test() {
	set_build_env

	# Verify compilation of all boards
	emake "${EC_OPTS[@]}" buildall
}
