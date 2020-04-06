# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @MAINTAINER:
# Chromium OS System Services Team
# @AUTHOR
# The Chromium OS Authors <chromium-os-dev@chromium.org>
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new
# @BLURB: Helper eclass for building DLC packages.
# @DESCRIPTION:
# Handles building the DLC image and metadata files and dropping them into
# locations where they can be picked up by the build process and hosted on
# Omaha, respectively.

if [[ -z "${_ECLASS_DLC}" ]]; then
_ECLASS_DLC="1"

inherit cros-constants

# Check for EAPI 6+.
case "${EAPI:-0}" in
[012345]) die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
esac

DEPEND="chromeos-base/update_engine"
DLC_BUILD_DIR="build/rootfs/dlc"

# @ECLASS-VARIABLE: DLC_NAME
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# The name of the DLC to show on the UI.

# @ECLASS-VARIABLE: DLC_PREALLOC_BLOCKS
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# The number of blocks to preallocate for each of the the DLC A/B partitions.
# Block size is 4 KiB.

# Other optional DLC ECLASS-VARAIBLES

# @ECLASS-VARIABLE: DLC_DESCRIPTION
# @DESCRIPTION:
# A human readable description for DLC. (Default is ${DESCRIPTION})

# @ECLASS-VARIABLE: DLC_ID
# @DESCRIPTION:
# Unique ID for the DLC among all DLCs. Needed to generate metadata for
# imageloader. Used in creating directories for the image file and metadata. It
# cannot contain '_' or '/'. (Default is ${PN})
: "${DLC_ID:=${PN}}"

# @ECLASS-VARIABLE: DLC_PACKAGE
# @DESCRIPTION:
# Unique ID for the package in the DLC. Each DLC can have multiple
# packages. Needed to generate metadata for imageloader. Used in creating
# directories for the image file and metadata. It cannot contain '_' or '/'.
# (Default is ${PN}-package)
: "${DLC_PACKAGE:=${PN}-package}"

# @ECLASS-VARIABLE: DLC_VERSION
# @DESCRIPTION:
# Version of the DLC being built. (Default is ${PVR})
: "${DLC_VERSION:=${PVR}}"

# @ECLASS-VARIABLE: DLC_FS_TYPE
# @DEFAULT UNSET
# @DESCRIPTION:
# Specify the type of filesystem for the DLC image. Currently we only support
# squashfs.

# @ECLASS-VARIABLE: DLC_PRELOAD
# @DESCRIPTION:
# Determines whether to preload the DLC for test images. A boolean must be
# passed in. (Default is false)
: "${DLC_PRELOAD:="false"}"

# @ECLASS-VARIABLE: DLC_ENABLED
# @DESCRIPTION:
# Determines whether the package will be a DLC package or regular package.
# By default, the package is a DLC package and the files will be installed in
# ${DLC_BUILD_DIR}/${DLC_ID}/${DLC_PACKAGE}/root, but if the variable is set to
# "false", all the functions will ignore the path suffix and everything that
# would have been installed inside the DLC, gets installed in the rootfs.
# (Default is true)
: "${DLC_ENABLED:="true"}"

# @FUNCTION: dlc_get_path
# @USAGE:
# @RETURN:
# Returns the path where the DLC files are being installed.
dlc_get_path() {
	if [[ "${DLC_ENABLED}" != "true" ]]; then
		echo "/"
	else
		[[ -z "${DLC_ID}" ]] && die "DLC_ID undefined"
		[[ -z "${DLC_PACKAGE}" ]] && die "DLC_PACKAGE undefined"
		echo "/${DLC_BUILD_DIR}/${DLC_ID}/${DLC_PACKAGE}/root"
	fi
}

# @FUNCTION: dlc_src_install
# @DESCRIPTION:
# Installs DLC files into
# /build/${BOARD}/${DLC_BUILD_DIR}/${DLC_ID}/${DLC_PACKAGE}/root.
dlc_src_install() {
	[[ "${DLC_ENABLED}" =~ ^(true|false)$ ]] || die "Invalid DLC_ENABLED value"
	if [[ "${DLC_ENABLED}" != "true" ]]; then
		return
	fi

	# Required.
	[[ -z "${DLC_NAME}" ]] && die "DLC_NAME undefined"
	[[ -z "${DLC_PREALLOC_BLOCKS}" ]] && die "DLC_PREALLOC_BLOCKS undefined"

	# Optional, but error if derived default values are empty.
	: "${DLC_DESCRIPTION:=${DESCRIPTION}}"
	[[ -z "${DLC_DESCRIPTION}" ]] && die "DLC_DESCRIPTION undefined"
	[[ -z "${DLC_ID}" ]] && die "DLC_ID undefined"
	[[ -z "${DLC_PACKAGE}" ]] && die "DLC_PACKAGE undefined"
	[[ -z "${DLC_VERSION}" ]] && die "DLC_VERSION undefined"
	[[ "${DLC_PRELOAD}" =~ ^(true|false)$ ]] || die "Invalid DLC_PRELOAD value"

	local args=(
		--install-root-dir="${D}"
		--pre-allocated-blocks="${DLC_PREALLOC_BLOCKS}"
		--version="${DLC_VERSION}"
		--id="${DLC_ID}"
		--package="${DLC_PACKAGE}"
		--name="${DLC_NAME}"
		--description="${DLC_DESCRIPTION}"
		--build-package
	)

	if [[ -n "${DLC_FS_TYPE}" ]]; then
		args+=( --fs-type="${DLC_FS_TYPE}" )
	fi

	if [[ "${DLC_PRELOAD}" == "true" ]]; then
		args+=( --preload )
	fi

	"${CHROMITE_BIN_DIR}"/build_dlc "${args[@]}" \
		|| die "build_dlc failed."
}

EXPORT_FUNCTIONS src_install

fi
