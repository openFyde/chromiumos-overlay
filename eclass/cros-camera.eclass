# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cros-camera.eclass
# @MAINTAINER:
# Chromium OS Camera Team
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new (with label Build)
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/HEAD/eclass/@ECLASS@
# @BLURB: helper eclass for building Chromium package in src/platform2/camera
# @DESCRIPTION:
# Packages in src/platform2/camera are in active development. We want builds
# to be incremental and fast. This centralized the logic needed for this.

inherit multilib

IUSE="
	march_alderlake
	march_armv8
	march_bdver4
	march_corei7
	march_goldmont
	march_silvermont
	march_skylake
	march_tigerlake
	march_tremont
	march_znver1
"

REQUIRED_USE="
	?? ( march_alderlake march_bdver4 march_corei7 march_goldmont march_silvermont march_skylake march_tigerlake march_tremont march_znver1 )
	^^ ( amd64 arm arm64 )
"

# @FUNCTION: cros-camera_dohal
# @USAGE: <source HAL file> <destination HAL file>
# @DESCRIPTION:
# Install the given camera HAL library to /usr/lib/camera_hal or
# /usr/lib64/camera_hal, depending on the architecture and/or platform.
cros-camera_dohal() {
	[[ $# -eq 2 ]] || die "Usage: ${FUNCNAME[0]} <src> <dst>"

	local src=$1
	local dst=$2
	(
		insinto "/usr/$(get_libdir)/camera_hal"
		newins "${src}" "${dst}"
	)
}

# @FUNCTION: cros-camera_get_arch_march_path
# @USAGE:
# @DESCRIPTION:
# Some libraries store the .so files built by different "-march" configuration
# under "${arch}-${march}" folders. This function returns the "${arch}-${march}"
# path according to the use flags.
cros-camera_get_arch_march_path() {
	if use march_alderlake; then
		echo "x86_64-alderlake"
	elif use march_armv8; then
		echo "armv7-armv8-a+crc"
	elif use march_bdver4; then
		echo "x86_64-bdver4"
	elif use march_corei7; then
		echo "x86_64-corei7"
	elif use march_goldmont; then
		echo "x86_64-goldmont"
	elif use march_silvermont; then
		echo "x86_64-silvermont"
	elif use march_skylake; then
		echo "x86_64-skylake"
	elif use march_tigerlake; then
		echo "x86_64-tigerlake"
	elif use march_tremont; then
		echo "x86_64-tremont"
	elif use march_znver1; then
		echo "x86_64-znver1"
	elif use amd64; then
		echo "x86_64"
	elif use arm; then
		echo "armv7"
	elif use arm64; then
		echo "arm"
	else
		die "Unknown microarchitecture"
	fi
}
