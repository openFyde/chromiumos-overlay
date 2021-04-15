# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="platform/empty-project"

inherit cros-unibuild cros-workon

DESCRIPTION="Chromium OS-specific configuration"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/config/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="fuzzer"

DEPEND="
	!fuzzer? ( virtual/chromeos-config-bsp:= )
"
RDEPEND="${DEPEND}"

# This ebuild creates the Chrome OS master configuration file stored in
# ${UNIBOARD_JSON_INSTALL_PATH}. See go/cros-unified-builds-design for
# more information.

# Merges all of the source YAML config files and generates the
# corresponding build config and platform config files.
src_compile() {
	local yaml_files=( "${SYSROOT}${UNIBOARD_YAML_DIR}/"*.yaml )
	local input_yaml_files=()
	local yaml="${WORKDIR}/config.yaml"
	local c_file="${WORKDIR}/config.c"
	local configfs_image="${WORKDIR}/configfs.img"
	local gen_yaml="${SYSROOT}${UNIBOARD_YAML_DIR}/config.yaml"
	# Protobuf based configs generate JSON directly with no YAML.
	if [[ -f "${SYSROOT}${UNIBOARD_YAML_DIR}/project-config.json" ]]; then
		cp "${SYSROOT}${UNIBOARD_YAML_DIR}/project-config.json" "${yaml}" || die
	elif [[ "${yaml_files[0]}" =~ .*[a-z_]+\.yaml$ ]]; then
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
	fi

	if [[ -f "${yaml}" ]]; then
		cros_config_schema -c "${yaml}" \
			--configfs-output "${configfs_image}" -g "${WORKDIR}" -f "True" \
			|| die "cros_config_schema failed for platform config."
	else
		einfo "Emitting empty C interface config for mosys."
		cp "${FILESDIR}/empty_config.c" "${c_file}"
	fi
}

src_install() {
	# Get the directory name only, and use that as the install directory.
	insinto "${UNIBOARD_JSON_INSTALL_PATH%/*}"
	if [[ -e "${WORKDIR}/configfs.img" ]]; then
		doins "${WORKDIR}/configfs.img"
	fi

	insinto "${UNIBOARD_YAML_DIR}"
	doins "${WORKDIR}/config.c"
	if [[ -e "${WORKDIR}/config.yaml" ]]; then
		doins "${WORKDIR}/config.yaml"
	fi
}

# @FUNCTION: _verify_config_dump
# @USAGE: [source-yaml] [expected-json]
# @INTERNAL
# @DESCRIPTION:
# Dumps the cros_config_host contents and verifies expected file match.
#   $1: Source YAML config file used to generate JSON dump.
#   $2: Expected JSON output file that is verified against.
_verify_config_dump() {
	local source_yaml="$1"
	local expected_json="$2"

	local expected_path="${SYSROOT}${CROS_CONFIG_TEST_DIR}/${expected_json}"
	local source_path="${SYSROOT}${UNIBOARD_YAML_DIR}/${source_yaml}"
	local actual_path="${WORKDIR}/${expected_json}"
	local merged_path="${WORKDIR}/${source_yaml}"
	if [[ -e "${expected_path}" ]]; then
		if [[ -e "${source_path}" ]]; then
			cros_config_schema -o "${merged_path}" -m "${source_path}" \
				|| die "cros_config_schema failed for build config."
			cros_config_host -c "${merged_path}" dump-config > "${actual_path}"
			verify_file_match "${expected_path}" "${actual_path}"
		else
			eerror "Source YAML ${source_path} doesn't exist for checking" \
				"against expected JSON dump ${expected_path}"
			die
		fi
	fi
}

src_test() {
	_verify_config_dump model.yaml config_dump.json
	_verify_config_dump private-model.yaml config_dump-private.json
}
