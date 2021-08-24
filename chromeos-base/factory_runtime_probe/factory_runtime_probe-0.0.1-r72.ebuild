# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="abf6daab00aee9f7e2d8c155785bc9779bae8ef1"
CROS_WORKON_TREE=("97bdcefe463bb514ecfb75bb81a7b653b11a9fbd" "36a7add9183037f0a2433b9d4a4693afc7cdf356" "700790ded5544bd75fae304df510998a64678202" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
