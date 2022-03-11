# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
#
# Standardizes the setup for chromeos-config-bsp ebuilds across
# all overlays based on config managed in the project specific
# repos (located under src/project).

# Check for EAPI 7+
case "${EAPI:-0}" in
7) ;;
*) die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
esac


# @ECLASS-VARIABLE: PROGRAM
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# Name of the program under src/program
: "${PROGRAM:=alpha}"


# @ECLASS-VARIABLE: PROJECTS
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# Names of the projects under src/project/$PROGRAM/ that will be
# included in this build.
: "${PROJECTS:=(one two three)}"

PROJECT_PREFIX="project_"
PROJECT_ALL="${PROJECT_PREFIX}all"
IUSE="${PROJECT_ALL} ${PROJECTS[*]/#/${PROJECT_PREFIX}}"

# Watch for any change anywhere in the projects or program
export CONFIG_ROOT=""

inherit cros-unibuild cros-constants

SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/${PF}"

BDEPEND="
	dev-go/lucicfg
"

EXPORT_FUNCTIONS src_compile src_install

cros-config-bsp_build_config() {
	local config_dir=$1
	local starlark_file=$2
	lucicfg generate --config-dir "${config_dir}" "${starlark_file}" \
		|| die "Failed to generate config under $(pwd)."
}

cros-config-bsp_proto_converter() {
	local program_config=$1
	local project_config=$2
	local output_dir=$3

	if [[ ! -e "${program_config}" || ! -e "${project_config}" ]]; then
		die "'${program_config}' and '${project_config}' must exist."
	fi

	rm -rf "${output_dir}"
	mkdir -p "${output_dir}"
	cros_config_proto_converter \
		--output "${output_dir}/project-config.json" \
		--program_config "${program_config}" \
		--project_configs "${project_config}" \
		|| die "Failed to run cros_config_proto_converter."
}

cros-config-bsp_gen_config() {
	# Re-establish the symlinks as they exist in the source tree.
	ln -sfT "${S}/config" "${S}/${PROGRAM}/config" \
		|| die "Failed to create '${PROGRAM}' link."
	(
		cd "${S}/${PROGRAM}" || die "Unable to cd into ${PROGRAM}."
		cros-config-bsp_build_config generated config.star
	)
	local project
	for project in "${PROJECTS[@]}"; do
		ln -sfT "${S}/config" "${S}/${project}/config" \
			|| die "Failed to create '${project}/config' link."
		ln -sfT "${S}/${PROGRAM}" "${S}/${project}/program" \
			|| die "Failed to create '${project}/program' link."
		local output_dir="sw_build_config/platform/chromeos-config/generated"
		(
			cd "${S}/${project}" || die "Unable to cd into ${project}."
			cros-config-bsp_build_config generated config.star
			cros-config-bsp_proto_converter "program/generated/config.jsonproto" \
				"generated/config.jsonproto" "${output_dir}"
		)
	done
}

cros-config-bsp_src_compile() {
	cros-config-bsp_gen_config
	platform_json_compile
}

cros-config-bsp_src_install() {
	platform_json_install

	unibuild_install_files arc-files "${WORKDIR}/project-config.json"
	unibuild_install_files thermal-files "${WORKDIR}/project-config.json"
	unibuild_install_touch_files "${WORKDIR}/project-config.json"
	unibuild_install_files intel-wifi-sar-files "${WORKDIR}/project-config.json"
}
