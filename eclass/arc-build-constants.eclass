# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

if [[ -z ${_ARC_BUILD_CONSTANTS_ECLASS} ]]; then
_ARC_BUILD_CONSTANTS_ECLASS=1

# USE flags corresponding to different container versions.
ANDROID_CONTAINER_VERS=(
	android-container-master-arc-dev
	android-container-nyc
	android-container-pi
	android-container-qt
)

# USE flags corresponding to different VM versions.
ANDROID_VM_VERS=(
	android-vm-pi
)

IUSE="arcvm cheets ${ANDROID_CONTAINER_VERS[*]} ${ANDROID_VM_VERS[*]}"

REQUIRED_USE="
	^^ ( ${ANDROID_CONTAINER_VERS[*]} ${ANDROID_VM_VERS[*]} )
	!arcvm? ( ^^ ( ${ANDROID_CONTAINER_VERS[*]} ) )
	arcvm? ( ^^ ( ${ANDROID_VM_VERS[*]} ) )
"

# @FUNCTION: arc-build-constants-configure
# @DESCRIPTION:
# Configures ARC variables for container or VM build:
# - ARC_PREFIX: Path to root directory of ARC installation relative to sysroot.
# - ARC_VENDOR_DIR: Path to install directory for /vendor files relative to sysroot.
# - ARC_ETC_DIR: Path to install directory for /etc files relative to sysroot.
# - ARC_VERSION_CODENAME: Selected Android version.
arc-build-constants-configure() {
	if ! use cheets; then
		# ARC is unavailable when the cheets flag is not set.
		return
	fi

	# TODO(alexlau): Update this when we need to build ARC++ and ARCVM together.
	if use arcvm; then
		ARC_PREFIX="/opt/google/vms/android"
	else
		ARC_PREFIX="/opt/google/containers/android"
	fi

	ARC_VENDOR_DIR="/build/rootfs${ARC_PREFIX}/vendor"
	ARC_ETC_DIR="/build/rootfs${ARC_PREFIX}/etc"
}

fi
