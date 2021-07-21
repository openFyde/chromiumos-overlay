# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d9b238c2468cd54fba11a2243d3bf1ae9ffee975"
CROS_WORKON_TREE=("cc8ae75ea68e5c37c867b396c0540c8a109ed460" "14a9937adc823905669b1a5884350cb225cc665a" "c20759996ee5d7b005b7d16009e7b7e7ee1342f8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config runtime_probe .gn"

PLATFORM_SUBDIR="runtime_probe"

inherit cros-workon platform

DESCRIPTION="Device component probe tool **for factory environment**."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/runtime_probe/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros-debug generated_cros_config unibuild +factory_runtime_probe"

# TODO(yhong): Extract common parts with runtime_probe-9999.ebuild to a shared
#     eclass.

COMMON_DEPEND="
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config:= )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
	chromeos-base/chromeos-config-tools:=
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/ec-utils
"

# Add vboot_reference as build time dependency to read cros_debug status
DEPEND="${COMMON_DEPEND}
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
