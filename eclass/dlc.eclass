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

# Check for EAPI 6+.
case "${EAPI:-0}" in
[012345]) die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
esac

# @ECLASS-VARIABLE: DLC_ID
# @REQUIRED
# @DEFAULT UNSET
# @DESCRIPTION:
# Unique ID for the DLC. Needed to generate metadata for imageloader. Used in
# creating directories for the image file and metadata.

# @ECLASS-VARIABLE: DLC_NAME
# @REQUIRED
# @DEFAULT UNSET
# @DESCRIPTION:
# Name of the DLC being built.

# @ECLASS-VARIABLE: DLC_VERSION
# @REQUIRED
# @DEFAULT UNSET
# @DESCRIPTION:
# Version of the DLC being built.

# @ECLASS-VARIABLE: DLC_FS_TYPE
# @REQUIRED
# @DEFAULT UNSET
# @DESCRIPTION:
# Specify the type of filesystem for the DLC image. Currently we only support
# squashfs.

# @ECLASS-VARIABLE: DLC_PREALLOC_BLOCKS
# @REQUIRED
# @DEFAULT UNSET
# @DESCRIPTION:
# The number of blocks to preallocate for each of the the DLC A/B partitions.
# Block size is 4 KiB.

# @ECLASS-VARIABLE: DLC_ARTIFACT_DIR
# @REQUIRED
# @DEFAULT UNSET
# @DESCRIPTION:
# Path to folder containing DLC artifacts to be packaged. Anything that should
# be included in the DLC image should be in this folder when dlc_src_install is
# called.

# @FUNCTION: dlc_src_install
# @DESCRIPTION:
# Packages DLC artifacts and installs metadata to /opt/google/${DLC_ID}. DLC
# images are moved to a temporary directory at /build/rootfs/dlc/${DLC_ID}.
dlc_src_install() {
	[[ -z "${DLC_ID}" ]] && die "DLC_ID undefined"
	[[ -z "${DLC_NAME}" ]] && die "DLC_NAME undefined"
	[[ -z "${DLC_VERSION}" ]] && die "DLC_VERSION undefined"
	[[ -z "${DLC_FS_TYPE}" ]] && die "DLC_FS_TYPE undefined"
	[[ -z "${DLC_PREALLOC_BLOCKS}" ]] && die "DLC_PREALLOC_BLOCKS undefined"
	[[ -z "${DLC_ARTIFACT_DIR}" ]] && die "DLC_ARTIFACT_DIR undefined"

	if [[ "${DLC_FS_TYPE}" == "ext4" ]]; then
		die "ext4 unsupported, see https://crbug.com/890060"
	fi

	DLC_META_DIR="${D}/opt/google/dlc/dlc_id-${DLC_ID}"
	DLC_IMG_DIR="${D}/build/rootfs/dlc/dlc_id-${DLC_ID}"

	mkdir -p "${DLC_META_DIR}" "${DLC_IMG_DIR}" || die

	# TODO(crbug.com/890060): support ext4, we currently get sandbox violations
	"${CHROMITE_BIN_DIR}"/build_dlc \
		--img-dir="${DLC_IMG_DIR}" \
		--meta-dir="${DLC_META_DIR}" \
		--src-dir="${DLC_ARTIFACT_DIR}" \
		--fs-type="${DLC_FS_TYPE}" \
		--pre-allocated-blocks="${DLC_PREALLOC_BLOCKS}" \
		--version="${DLC_VERSION}" \
		--id="${DLC_ID}" \
		--name="${DLC_NAME}" \
		|| die "build_dlc failed to generate DLC image and metadata"
}

EXPORT_FUNCTIONS src_install

fi
