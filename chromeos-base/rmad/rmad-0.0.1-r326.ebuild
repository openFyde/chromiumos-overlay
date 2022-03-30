# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="333ec877d7bb10d72a63c372db16ae5f1dbac0b9"
CROS_WORKON_TREE=("20fecf8e8aefa548043f2cb501f222213c15929d" "c440263ac6c3eaa96b9b5d5e6d1c093b8835f5d9" "1b6791d8f3bd43faefbaff3664ccf8eeabdfa502" "41f71be015aabb82c9cc3180606b5aced4946f8e" "f41b144d7a385199fa8955db004645f1e860d688" "19177cddca0ff40fd72cfc8dbb8cd790fb9a56dd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk chromeos-config hardware_verifier libmems metrics rmad .gn"

PLATFORM_SUBDIR="rmad"

inherit cros-workon cros-unibuild platform tmpfiles user

DESCRIPTION="ChromeOS RMA daemon."
HOMEPAGE=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cr50_onboard iioservice ti50_onboard"

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/minijail:=
"

RDEPEND="
	${COMMON_DEPEND}
	cr50_onboard? ( chromeos-base/chromeos-cr50 )
	iioservice? ( chromeos-base/iioservice_simpleclient )
	ti50_onboard? ( chromeos-base/chromeos-ti50 )
	chromeos-base/croslog
	chromeos-base/hardware_verifier
	chromeos-base/libmems
	chromeos-base/runtime_probe
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/cryptohome-client:=
	chromeos-base/metrics:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=
	chromeos-base/tpm_manager-client:=
	chromeos-base/vboot_reference:=
"

pkg_preinst() {
	# Create user and group for RMA.
	enewuser "rmad"
	enewgroup "rmad"
}

src_install() {
	platform_install

	dotmpfiles tmpfiles.d/*.conf
}

platform_pkg_test() {
	platform test_all
}
