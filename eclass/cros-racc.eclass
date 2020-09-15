# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cros-racc.eclass
# @BLURB: helper eclass for building Chromium packages of RACC
# @DESCRIPTION:
# Packages src/platform2/{hardware_verifier,runtime_probe} are in active
# development.  We have to add board-specific rules manually.

# @FUNCTION: cros-racc_install_config_files
# @DESCRIPTION:
# Install AVL runtime verification config files.
# https://bugs.chromium.org/p/chromium/issues/detail?id=959178 for more details.
cros-racc_install_config_files() {
	einfo "cros-racc install_config_files"
	for model in "$@"; do
		insinto "/etc/runtime_probe/${model}"
		doins "${FILESDIR}/runtime_probe/${model}/probe_config.json"
	done

	insinto /etc/hardware_verifier
	doins "${FILESDIR}/hw_verification_spec.prototxt"
}
