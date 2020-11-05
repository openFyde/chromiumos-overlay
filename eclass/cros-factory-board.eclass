# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

inherit cros-factory

# @ECLASS: cros-factory-board.eclass
# @MAINTAINER:
# The Chromium OS Authors <chromium-os-dev@chromium.org>
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new (with label Build)
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/master/eclass/@ECLASS@
# @BLURB: Eclass to help creating per-project factory resources.

# Check for EAPI 7+
case "${EAPI:-0}" in
	0|1|2|3|4|5|6)
		die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
esac

# @FUNCTION: cros-factory-board_install_project_config
# @USAGE:
# @DESCRIPTION:
# Install project config into the toolkit and the factory bundle.
# @EXAMPLE:
# To install project config:
#
# @CODE
#  cros-factory-board_install_project_config
# @CODE
cros-factory-board_install_project_config() {
	einfo "Installing project_config ..."
	local configs=()
	local project_config_workdir="${WORKDIR}/project_config"
	local package_dir="${WORKDIR}/project_config_result"
	local package="${package_dir}/project_config.tar.gz"
	mkdir -p "${project_config_workdir}" "${package_dir}"
	shopt -s nullglob
	local config_source_dir
	for config_source_dir in "${S}"/*/*/"factory/generated"; do
		local project_dir=$(dirname -- "$(dirname -- "${config_source_dir}")")
		local PROGRAM=$(basename -- "$(dirname -- "${project_dir}")")
		local PROJECT=$(basename -- "${project_dir}")
		for file in "${config_source_dir}"/*; do
			local new_file="${PROGRAM}_${PROJECT}_$(basename -- "${file}")"
			cp -f "${file}" "${project_config_workdir}/${new_file}" || die
			configs+=("${new_file}")
		done
	done
	shopt -u nullglob
	# tar will fail to create empty archive so we add a file here.
	if [[ ${#configs[@]} -eq 0 ]]; then
		local new_file="this_is_an_empty_archive"
		touch "${project_config_workdir}/${new_file}" || die
		configs+=("${new_file}")
	fi
	# Create a project config tar as a bundle component that can be uploaded to
	# Dome or put inside RMA shim.
	tar -I pigz -cf "${package}" \
		--owner=0 --group=0 -C "${project_config_workdir}" "${configs[@]}" || die
	insinto "/usr/local/factory/bundle/project_config"
	doins "${package}"
	# Install project_config into the toolkit directly.
	factory_create_resource "factory-project-config" "${WORKDIR}" "." \
		"project_config"
}

# @FUNCTION: cros-factory-board_install_project_overlay
# @USAGE:
# @DESCRIPTION:
# Install project overlay into the toolkit.
# @EXAMPLE:
# To install project overlay:
#
# @CODE
#  cros-factory-board_install_project_overlay
# @CODE
cros-factory-board_install_project_overlay() {
	einfo "Installing project overlay ..."
	shopt -s nullglob
	local overlay_source_dir
	for overlay_source_dir in "${S}"/*/*/"factory/files"; do
		local project_dir=$(dirname -- "$(dirname -- "${overlay_source_dir}")")
		local PROGRAM=$(basename -- "$(dirname -- "${project_dir}")")
		local PROJECT=$(basename -- "${project_dir}")
		echo "overlay_source_dir:${overlay_source_dir}"
		# Install project overlay into the toolkit directly.
		factory_create_resource "factory-${PROGRAM}-${PROJECT}-overlay" \
			"${overlay_source_dir}" "." "."
	done
	shopt -u nullglob
}

cros-factory-board_src_install() {
	cros-factory-board_install_project_config
	cros-factory-board_install_project_overlay
}

EXPORT_FUNCTIONS src_install
