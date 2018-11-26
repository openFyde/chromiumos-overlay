# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Check for EAPI 4+
case "${EAPI:-0}" in
4|5|6) ;;
*) die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
esac

# @ECLASS-VARIABLE: UNIBOARD_CROS_CONFIG_DIR
# @DESCRIPTION:
#  This is the installation directory of cros-config data.
UNIBOARD_CROS_CONFIG_DIR="/usr/share/chromeos-config"

# @ECLASS-VARIABLE: UNIBOARD_JSON_INSTALL_PATH
# @DESCRIPTION:
#  This is the filename of the master configuration for use with doins.
UNIBOARD_JSON_INSTALL_PATH="${UNIBOARD_CROS_CONFIG_DIR}/config.json"

# @ECLASS-VARIABLE: UNIBOARD_YAML_DIR
# @DESCRIPTION:
#  This is the installation directory of the yaml source files.
UNIBOARD_YAML_DIR="${UNIBOARD_CROS_CONFIG_DIR}/yaml"

# @ECLASS-VARIABLE: UNIBOARD_YAML_CONFIG
# @DESCRIPTION:
#  This is the installation path to the YAML source file.
UNIBOARD_YAML_CONFIG="${UNIBOARD_YAML_DIR}/config.yaml"

# @ECLASS-VARIABLE: UNIBOARD_C_CONFIG
# @DESCRIPTION:
#  This is the installation path to the C source file.
UNIBOARD_C_CONFIG="${UNIBOARD_YAML_DIR}/config.c"

# @ECLASS-VARIABLE: CROS_CONFIG_TEST_DIR
# @DESCRIPTION:
#  Local to install build specific cros_config test files.
#  These are used for chromeos-config integration testing that verifies
#  the integrity of the config changes.
CROS_CONFIG_TEST_DIR="/tmp/chromeos-config"

# @ECLASS-VARIABLE: CROS_CONFIG_BUILD_CONFIG_DUMP_FILE
# @DESCRIPTION:
#  Local to install build specific cros_config test files.
#  These are used for chromeos-config integration testing that verifies
#  the integrity of the config changes.
CROS_CONFIG_BUILD_CONFIG_DUMP_FILE="config_dump.json"

# @FUNCTION: _find_configs
# @USAGE: <directory> <extension>
# @INTERNAL
# @DESCRIPTION:
# Find .json/.yaml files in a given directory tree.
# Args:
#   $1: Directory to search.
#   $2: Extension to search for (.json or .yaml).
# Returns:
#   Exports a 'files' variable containing the array of files found.
# TODO(gmeinke): rename this to something more generic.
_find_configs() {
	local file

	while read -d $'\0' -r file; do
		files+=( "${file}" )
	done < <(find "$1" -name "*$2" -print0)
}

# @FUNCTION: _insert_config_files
# @USAGE: <files array> <output directory>
# @INTERNAL
# @DESCRIPTION:
# Do a newins to the output directory for each file in the input array.
# Args:
#   $1: Files array to insert.
#   $2: Output directory to newins into.
#   $3: prefix to prepend to filename.
# Returns:
#   None.
_insert_config_files() {
	[[ $# -eq 3 ]] || die "${FUNCNAME}: takes three arguments"
	local ins_files=($1)
	local output_dir="$2"
	local prefix="$3"
	if [[ "${#ins_files[@]}" -gt 0 ]]; then
		einfo "Installing ${#ins_files[@]} files to ${output_dir}"
		# Avoid polluting callers with our newins.
		(
			insinto "${output_dir}"
			for f in "${ins_files[@]}"; do
				local dest="${prefix}${f##*/}"
				einfo "Copying ${f} -> ${dest}"
				newins "${f}" "${dest}"
			done
		)
	fi
}

# @FUNCTION: _install_model_files
# @USAGE: [prefix]
# @INTERNAL
# @DESCRIPTION:
# Find .yaml files in a given directory tree.
# Install model files with a given prefix:
# Args:
#   $1: Prefix to use (either "" or "private-")
_install_model_files() {
	[[ $# -eq 1 ]] || die "${FUNCNAME}: takes one arguments"

	local prefix="$1"
	local files

	files=()
	_find_configs "${FILESDIR}" ".yaml"
	_insert_config_files "${files[*]}" "${UNIBOARD_YAML_DIR}" "${prefix}"
}

# @FUNCTION: install_private_model_files
# @USAGE:
# @DESCRIPTION:
# Installs all .yaml files for the current board. This is intended to be called
# from the chromeos-config-<board> private ebuild. The files are named
# "private-<fname>.yaml".
install_private_model_files() {
	[[ $# -eq 0 ]] || die "${FUNCNAME}: takes no arguments"

	_install_model_files "private-"
}

# @FUNCTION: install_model_files
# @USAGE:
# @DESCRIPTION:
# Installs all .yaml files for the current board. This is intended to be called
# from the chromeos-config-<board> public ebuild. The files are named
# "<fname>.yaml".
install_model_files() {
	[[ $# -eq 0 ]] || die "${FUNCNAME}: takes no arguments"

	_install_model_files ""
}

# @FUNCTION: cros_config_host_local
# @USAGE:
# @DESCRIPTION:
# Invokes cros_config_host using the config directly from
# chromeos-config-bsp/files
# Args:
#   $1: Command to pass to cros_config_host
cros_config_host_local() {
	# This function is called before FILESDIR is set so figure it out from
	# the ebuild filename.
	local basedir="$(dirname "${EBUILD}")/.."
	local configdir="${basedir}/chromeos-config-bsp/files"
	local files

	if [[ -e "${configdir}/model.yaml" ]]; then
		echo $(cros_config_host -c "${configdir}/model.yaml" "$1")
	else
		# We cannot die here if there are no config files as this function is
		# called by non-unibuild boards. We just need to output an empty
		# config. But do skip this if there is no config BSP directory at all.
		echo ""
	fi
}

# @FUNCTION: _unibuild_common_install
# @USAGE: [command]
# @INTERNAL
# @DESCRIPTION:
# Common installation function.
# Install files from a relative path in FILESDIR to an absolute path in the
# root.
# Args:
#   $1: Command to pass to cros_config_host to get the files
_unibuild_common_install() {
	[[ $# -eq 1 ]] || die "${FUNCNAME}: takes one argument"

	local cmd="$1"
	local source dest origfile
	(cros_config_host "${cmd}" || die) |
	while read -r source; do
		read -r dest
		einfo "   - ${source}"
		insinto "$(dirname "${dest}")"
		# From EAPI4+ symbolic links are not dereferenced when
		# installing, but we want to dereference our links when
		# installing config files. Common config files may be linked
		# in the source directory, but the installed file should not be
		# a link especially since the installed folder structure is
		# different.
		origfile="$(readlink -f "${FILESDIR}/${source}")"
		newins "${origfile}" "$(basename "${dest}")"
	done
}

# @FUNCTION: unibuild_install_thermal_files
# @USAGE:
# @DESCRIPTION:
# Install files related to thermal operation. Currently this is only the DPTF
# (Dynamic Platform and Thermal Framework) datavaults, typically called dptf.dv
unibuild_install_thermal_files() {
	[[ $# -eq 0 ]] || die "${FUNCNAME}: takes no arguments"

	einfo "unibuild: Installing thermal files"
	_unibuild_common_install get-thermal-files
}

# @FUNCTION: _unibuild_install_fw
# @USAGE: [source] [dest] [symlink path]
# @INTERNAL
# @DESCRIPTION:
# Install touch firmware and create a symlink for 'request firmware' hotplug.
#   $1: Source filename
#   $2: Destination filename (in /opt/google)
#   $3: Full path to symlink in /lib/firmware
_unibuild_install_fw() {
	local source="$1"
	local dest="$2"
	local symlink="$3"

	elog "   - ${source} with symlink from ${symlink}"
	insinto "$(dirname "${dest}")"
	doins "${source}"
	dosym "${dest}" "${symlink}"
}

# @FUNCTION: unibuild_install_touch_files
# @USAGE:
# @DESCRIPTION:
# Install files related to touch firmware. This includes firmware for the
# touchscreen, touchpad and stylus.
unibuild_install_touch_files() {
	einfo "unibuild: Installing touch files"
	set -o pipefail
	cros_config_host get-touch-firmware-files |
	( while read -r source; do
		read -r dest
		read -r symlink
		_unibuild_install_fw "${FILESDIR}/${source}" "${dest}" "${symlink}"
	done ) || die "Failed to read config"
}

# @FUNCTION: unibuild_install_audio_files
# @USAGE:
# @DESCRIPTION:
# Install files related to audio. This includes cras, alsa and hotwording
# topology firmware.
unibuild_install_audio_files() {
	[[ $# -eq 0 ]] || die "${FUNCNAME}: takes no arguments"

	einfo "unibuild: Installing audio files"
	_unibuild_common_install get-audio-files
}

# @FUNCTION: unibuild_install_arc_files
# @USAGE:
# @DESCRIPTION: Install files related to arc++.
unibuild_install_arc_files() {
	[[ $# -eq 0 ]] || die "${FUNCNAME}: takes no arguments"

	einfo "unibuild: Installing arc++ files"
	local source dest
	(cros_config_host get-arc-files || die) |
	while read -r source; do
		read -r dest
		einfo "   - ${source}"
		insinto "$(dirname "${dest}")"
		newins "${FILESDIR}/${source}" "$(basename "${dest}")"
		chmod 755 "${D}/${dest}"
	done
}

# @FUNCTION: unibuild_install_bluetooth_files
# @USAGE:
# @DESCRIPTION:
# Install files related to bluetooth config.
unibuild_install_bluetooth_files() {
	[[ $# -eq 0 ]] || die "${FUNCNAME}: takes no arguments"

	einfo "unibuild: Installing bluetooth files"
	_unibuild_common_install get-bluetooth-files
}
