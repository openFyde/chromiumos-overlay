# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: arc-android-installer.eclass
# @MAINTAINER:
# ARC Team
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new (with label Build)
# @VCSURL:
# https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/HEAD/eclass/@ECLASS@
# @BLURB: helper eclass for building ARC
# @DESCRIPTION:
# This eclass is a wrapper for chromeos-base/android-installer. It provides
# helper functions to build ARC.

if [[ -z ${_ARC_ANDROID_INSTALLER_ECLASS} ]]; then
_ARC_ANDROID_INSTALLER_ECLASS=1

BDEPEND="chromeos-base/android-installer"

# @ECLASS-VARIABLE: ARC_ANDROID_INSTALLER_VERSION
# @DESCRIPTION:
# The version of android-installer to use.

# @ECLASS-VARIABLE: ARC_ANDROID_INSTALLER_ENV_LIST
# @DESCRIPTION:
# A list of environment variables to export to android-installer.
ARC_ANDROID_INSTALLER_ENV_LIST=()

# @ECLASS-VARIABLE: ARC_ANDROID_INSTALLER_USE_LIST
# @DESCRIPTION:
# A list of use flags to export to android-installer.
ARC_ANDROID_INSTALLER_USE_LIST=()

# @FUNCTION: arc-android-installer_helper
# @USAGE: <caller>
# @DESCRIPTION:
# A helper function to build the command to run the corresponding version of
# android-installer with proper --env/--use/--caller arguments.
arc-android-installer_helper() {
	if [[ $# != 1 ]]; then
		die "${FUNCNAME[0]}: invalid arguments: only caller is expected"
	fi
	local caller="$1"

	local cmd="android-installer"
	if [[ -v ARC_ANDROID_INSTALLER_VERSION ]]; then
		cmd+="_${ARC_ANDROID_INSTALLER_VERSION}"
	fi
	local env env_args=()
	for env in "${ARC_ANDROID_INSTALLER_ENV_LIST[@]}"; do
		env_args+=("--env=${env}=${!env}")
	done
	local use use_args=()
	for use in "${ARC_ANDROID_INSTALLER_USE_LIST[@]}"; do
		if use "${use}"; then
			use_args+=("--use=+${use}")
		else
			use_args+=("--use=-${use}")
		fi
	done
	local caller_arg="--caller=${caller}"
	"${cmd}" "${env_args[@]}" "${use_args[@]}" "${caller_arg}" || die "${FUNCNAME[0]}: android-installer failed"
}

# @FUNCTION: arc-android-installer_src_compile
# @DESCRIPTION:
# Run android-installer's src_compile phase.
arc-android-installer_src_compile() {
	if [[ $# != 0 ]]; then
		die "${FUNCNAME[0]}: invalid arguments: no argument is expected"
	fi

	arc-android-installer_helper "ebuild_src_compile"
}

fi
