# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

# @ECLASS: cros-zephyr.eclass
# @MAINTAINER:
# Chromium OS Firmware Team
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new (with label Build)
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/master/eclass/@ECLASS@
# @BLURB: helper eclass for building Zephyr-based firmware
# @DESCRIPTION:
# Builds the Zephyr EC firmware and installs into /firmware/<project>/ec.bin

# Check for EAPI 7+.
case "${EAPI:-0}" in
0|1|2|3|4|5|6) die "Unsupported EAPI=${EAPI:-0} for ${ECLASS} (7+ required)" ;;
*) ;;
esac

inherit toolchain-funcs cros-workon ninja-utils

IUSE="unibuild"
REQUIRED_USE="unibuild"

BDEPEND="
	dev-python/docopt
	dev-python/pykwalify
	dev-util/ninja
"

DEPEND="chromeos-base/chromeos-config"

# @ECLASS-VARIABLE: ZEPHYR_BASE
# @DESCRIPTION: Path to the Zephyr OS repo
# @INTERNAL

# @ECLASS-VARIABLE: ZEPHYR_CHROME
# @DESCRIPTION: Path to the ChromeOS Zephyr overlay repo
# @INTERNAL

# @ECLASS-VARIABLE: ZEPHYR_MODULES
# @DESCRIPTION: Array of module repos used in Zephyr build
# @INTERNAL

# @ECLASS-VARIABLE: ZEPHYR_BUILD_TARGET_NAMES
# @DESCRIPTION: List of names used for the build targets
# @INTERNAL

# @ECLASS-VARIABLE: ZEPHYR_BUILD_TARGET_PATHS
# @DESCRIPTION: List of relative paths under ${ZEPHYR_CHROME}/projects
# to the project directory for each build target.
# @INTERNAL

# @FUNCTION: cros-zephyr_gen_cmake
# @DESCRIPTION: output auto-generated cmake source on stdout
cros-zephyr_gen_cmake() {
	echo "set(ZEPHYR_BASE ${ZEPHYR_BASE} CACHE PATH \"Zephyr base\")"
	echo "set(ZEPHYR_MODULES ${ZEPHYR_MODULES[*]} CACHE STRING \"pre-cached modules\")"
}

# @FUNCTION: cros-zephyr_build_dir
# @DESCRIPTION: convert a target name to the zephyr build path
# @USAGE: <build_target_name>
cros-zephyr_build_dir() {
	echo "$(cros-workon_get_build_dir)/build-${1}"
}

# @FUNCTION: cros-zephyr_bin_name
# @DESCRIPTION: convert a target name to the zephyr bin name
# @USAGE: <build_target_name>
cros-zephyr_bin_name() {
	echo "$(cros-zephyr_build_dir "${1}")/zephyr/zephyr.bin"
}

# @FUNCTION: cros-zephyr_gen_makefile
# @DESCRIPTION: generate a Makefile which builds all targets
#
# We generate a Makefile so we can take advantage of "emake" for
# parallelism.  This is because a given unibuild board may have many
# zephyr targets to produce, so we can produce them all in parallel
# this way.
cros-zephyr_gen_makefile() {
	local name
	echo ".PHONY: all"
	echo -n "all:"
	for name in "${ZEPHYR_BUILD_TARGET_NAMES[@]}"; do
		echo -n " $(cros-zephyr_bin_name "${name}")"
	done
	echo
	for name in "${ZEPHYR_BUILD_TARGET_NAMES[@]}"; do
		cat <<EOF
$(cros-zephyr_bin_name "${name}"):
	ninja -C"$(cros-zephyr_build_dir "${name}")"
EOF
	done
}

# @FUNCTION: cros-zephyr_src_configure
# @DESCRIPTION: Setup the build directories and export zephyr variables.
cros-zephyr_src_configure() {
	ZEPHYR_BASE=""
	ZEPHYR_CHROME=""
	ZEPHYR_MODULES=()

	# Verify that the SDK is installed.
	if [[ ! -s /opt/zephyr-sdk/sdk_version ]]; then
		>&2 echo "ERROR: Zephyr SDK doesn't appear to be installed"
		>&2 echo "       Run src/platform/zephyr-chrome/import-sdk.py"
		die
	fi

	# We make assumptions about the purpose of each repo by the paths
	# in CROS_WORKON_DESTDIR.
	local destdir
	for destdir in "${CROS_WORKON_DESTDIR[@]}"; do
		case "${destdir}" in
			*/zephyr-base )
				ZEPHYR_BASE="${destdir}"
				;;
			*/zephyr-chrome )
				ZEPHYR_CHROME="${destdir}"
				;;
			*/modules/* )
				ZEPHYR_MODULES+=("${destdir}")
				;;
			* )
				die "Unrecognized zephyr repo: ${destdir}"
				;;
		esac
	done

	local name path
	ZEPHYR_BUILD_TARGET_NAMES=()
	ZEPHYR_BUILD_TARGET_PATHS=()
	while read -r name && read -r path; do
		ZEPHYR_BUILD_TARGET_NAMES+=("${name}")
		ZEPHYR_BUILD_TARGET_PATHS+=("${path}")
	done < <(cros_config_host get-firmware-build-combinations zephyr-ec)

	mkdir -p "$(cros-workon_get_build_dir)"
	cros-zephyr_gen_cmake >"$(cros-workon_get_build_dir)/.cmake"
	cros-zephyr_gen_makefile >"$(cros-workon_get_build_dir)/Makefile"

	# Zephyr environment variables.
	export ZEPHYR_BASE

	# We have to nuke all of the system environment variables, as
	# these won't work with target (bare metal) architecture.
	unset CC LD CFLAGS LDFLAGS CXX CXXFLAGS

	# Run cmake for each build target.
	for i in "${!ZEPHYR_BUILD_TARGET_NAMES[*]}"; do
		name="${ZEPHYR_BUILD_TARGET_NAMES[${i}]}"
		path="${ZEPHYR_BUILD_TARGET_PATHS[${i}]}"
		cmake -GNinja -B"$(cros-zephyr_build_dir "${name}")" \
			-S"${ZEPHYR_CHROME}/projects/${path}" \
			-C"$(cros-workon_get_build_dir)/.cmake" \
			|| die "cmake failed for ${name}"
	done
}

# @FUNCTION: cros-zephyr_src_compile
# @DESCRIPTION: compile all zephyr targets
cros-zephyr_src_compile() {
	emake -C"$(cros-workon_get_build_dir)" || die "compile failed"
}

# @FUNCTION: cros-ec_src_install
# @DESCRIPTION: install all zephyr targets into /firmware
cros-zephyr_src_install() {
	local target
	for target in "${ZEPHYR_BUILD_TARGET_NAMES[@]}"; do
		einfo "Installing zephyr.bin for ${target}..."
		insinto "/firmware/${target}"
		newins "$(cros-zephyr_bin_name "${target}")" "ec.bin"
	done
}

EXPORT_FUNCTIONS src_configure src_compile src_install
