# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

if [[ -z ${_ARC_BUILD_CONSTANTS_ECLASS} ]]; then
_ARC_BUILD_CONSTANTS_ECLASS=1

IUSE="arcvm"

arc-build-constants-configure() {
	# TODO(alexlau): Update this when we need to build ARC++ and ARCVM together.
	if use arcvm; then
		export ARC_PREFIX="/opt/google/vms/android"
	else
		export ARC_PREFIX="/opt/google/containers/android"
	fi

	export ARC_VENDOR_DIR="/build/rootfs${ARC_PREFIX}/vendor"
	export ARC_ETC_DIR="/build/rootfs${ARC_PREFIX}/etc"
}

fi
