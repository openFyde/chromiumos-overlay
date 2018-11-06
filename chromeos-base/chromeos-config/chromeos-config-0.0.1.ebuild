# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# We can drop this if cros-uniboard stops using cros-board.
CROS_BOARDS=( none )

inherit cros-unibuild toolchain-funcs

DESCRIPTION="Chromium OS-specific configuration"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="
	virtual/chromeos-config-bsp:=
"
RDEPEND="${DEPEND}"

# This ebuild creates the Chrome OS master configuration file stored in
# ${UNIBOARD_JSON_INSTALL_PATH}. See go/cros-unified-builds-design for
# more information.

# There is no workon source directory, so use the work directory.
S=${WORKDIR}

# Merges all of the source YAML config files and generates the
# corresponding build config and platform config files.
src_compile() {
	local yaml_files=( "${SYSROOT}${UNIBOARD_YAML_DIR}/"*.yaml )
	local input_yaml_files=()
	local yaml="${WORKDIR}/config.yaml"
	local c_file="${WORKDIR}/config.c"
	local json="${WORKDIR}/config.json"
	local gen_yaml="${SYSROOT}${UNIBOARD_YAML_DIR}/config.yaml"
	if [[ "${yaml_files[0]}" =~ .*[a-z_]+\.yaml$ ]]; then
		echo "# Generated YAML config file" > "${yaml}"
		for source_yaml in "${yaml_files[@]}"; do
			if [[ "${source_yaml}" != "${gen_yaml}" ]]; then
				einfo "Adding source YAML file ${source_yaml}"
				# Order matters here.  This will control how YAML files
				# are merged.  To control the order, change the name
				# of the input files to be in the order desired.
				input_yaml_files+=("${source_yaml}")
			fi
		done
		cros_config_schema -o "${yaml}" -m "${input_yaml_files[@]}" \
			|| die "cros_config_schema failed for build config."
		cros_config_schema -c "${yaml}" -o "${json}" -g "${c_file}" -f "True" \
			|| die "cros_config_schema failed for platform config."
	else
		einfo "Emitting empty c interface config for mosys."
		cp "${FILESDIR}/empty_config.c" "${c_file}"
	fi
}

src_install() {
	# Get the directory name only, and use that as the install directory.
	if [[ -e "${WORKDIR}/config.json" ]]; then
		insinto "${UNIBOARD_JSON_INSTALL_PATH%/*}"
		doins config.json
	fi
	insinto "${UNIBOARD_YAML_DIR}"
	doins config.c
	if [[ -e "${WORKDIR}/config.yaml" ]]; then
		doins config.yaml
	fi
}

src_test() {
	local expected_config="${SYSROOT}${CROS_CONFIG_TEST_DIR}/config_dump.json"
	local actual_config="${WORKDIR}/config_dump.json"
	if [[ -e "${expected_config}" ]]; then
		if [[ -e "${WORKDIR}/config.yaml" ]]; then
			cros_config_host -c "${WORKDIR}/config.yaml" dump-config > \
				"${actual_config}"
		fi
		einfo "Verifying ${expected_config} matches ${actual_config}"
		local expected_cksum="$(cksum "${expected_config}" | cut -d ' ' -f 1)"
		local actual_cksum="$(cksum "${actual_config}" | cut -d ' ' -f 1)"
		if [[ "${expected_cksum}" -ne "${actual_cksum}" ]]; then
			eerror "Generated config doesn't match expected config. \n" \
				"Generated config is available at: ${actual_config}\n" \
				"If this is an expected change, copy this change to the expected" \
				"config_dump.json file and commit with your CL.\n"
			die
		fi
		einfo "Successfully verified ${expected_config} matches ${actual_config}"
	fi
}

