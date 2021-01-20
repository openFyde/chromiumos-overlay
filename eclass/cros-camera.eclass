# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cros-camera.eclass
# @MAINTAINER:
# Chromium OS Camera Team
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new (with label Build)
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/master/eclass/@ECLASS@
# @BLURB: helper eclass for building Chromium package in src/platform2/camera
# @DESCRIPTION:
# Packages in src/platform2/camera are in active development. We want builds
# to be incremental and fast. This centralized the logic needed for this.

inherit multilib platform

# @FUNCTION: cros-camera_doheader
# @USAGE: <header files...>
# @DESCRIPTION:
# Install the given header files to /usr/include/cros-camera.
cros-camera_doheader() {
	(
		insinto "/usr/include/cros-camera"
		doins "$@"
	)
}

# @FUNCTION: cros-camera_dohal
# @USAGE: <source HAL file> <destination HAL file>
# @DESCRIPTION:
# Install the given camera HAL library to /usr/lib/camera_hal or
# /usr/lib64/camera_hal, depending on the architecture and/or platform.
cros-camera_dohal() {
	[[ $# -eq 2 ]] || die "Usage: ${FUNCNAME} <src> <dst>"

	local src=$1
	local dst=$2
	(
		insinto "/usr/$(get_libdir)/camera_hal"
		newins "${src}" "${dst}"
	)
}

# @FUNCTION: cros-camera_dopc
# @USAGE: <pkg-config template file>
# @DESCRIPTION:
# Generate the pkg-config file by replacing @INCLUDE_DIR@, @LIB_DIR@, and
# @LIBCHROME_VERS@ with the values detected at build time, then install the
# generated pkg-config file.
cros-camera_dopc() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <pc file template>"

	local in_pc_file=$1
	local out_pc_file="${WORKDIR}/${in_pc_file##*/}"
	out_pc_file="${out_pc_file%%.template}"
	local include_dir="/usr/include/cros-camera"
	local lib_dir="/usr/$(get_libdir)"

	sed -e "s|@INCLUDE_DIR@|${include_dir}|" -e "s|@LIB_DIR@|${lib_dir}|" \
		-e "s|@LIBCHROME_VERS@|$(libchrome_ver)|" \
		"${in_pc_file}" > "${out_pc_file}"
	(
		insinto "${lib_dir}/pkgconfig"
		doins "${out_pc_file}"
	)
}
