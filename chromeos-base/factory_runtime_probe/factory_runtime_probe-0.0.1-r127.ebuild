# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4481e87cb1f0478266277ee28a31db1b8e53e3b6"
CROS_WORKON_TREE=("8a107d83e7e0a12f330005e0cd66720e3d854a2e" "5f7d603abf935d71c4176e38908831a1ec2c71db" "1c2e22420fd0cb7599e4062db9b3ed50e31808fb" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config runtime_probe .gn"

PLATFORM_SUBDIR="runtime_probe"

inherit cros-workon cros-unibuild platform

DESCRIPTION="Device component probe tool **for factory environment**."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/runtime_probe/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros-debug +factory_runtime_probe"

# TODO(yhong): Extract common parts with runtime_probe-9999.ebuild to a shared
#     eclass.

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/ec-utils
"

# Add vboot_reference as build time dependency to read cros_debug status
DEPEND="${COMMON_DEPEND}
	chromeos-base/debugd-client:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=
	chromeos-base/vboot_reference:=
"

pkg_setup() {
	cros-workon_pkg_setup

	# Assert that the package is not "directly" installed into Chrome OS
	# images.  We currently only anticipate that files introduced by this
	# package being used as the source materials for other packages.
	if [[ "$(cros_target)" != "board_sysroot" ]]; then
		die "${PN} should never be installed into Chrome OS images directly."
	fi
}

src_install() {
	dobin "${OUT}/factory_runtime_probe"
	dobin "${OUT}/factory_runtime_probe_installer"
}
