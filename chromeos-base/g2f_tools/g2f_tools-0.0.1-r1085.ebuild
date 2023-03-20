# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="a97ea9f9e2993b3ea77452082edaf75a52e183b2"
CROS_WORKON_TREE=("017dc03acde851b56f342d16fdc94a5f332ff42e" "f6e104c11c530bd14d044a9d3ea7a03c9d235a7f" "bb0ca75967bdb31658c366e9b7d3b8c8b05a8ed0" "e1f223c8511c80222f764c8768942936a8de01e4" "cceee53aa238773d8042e0603613fd3eeed90784" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation metrics u2fd .gn"

PLATFORM_SUBDIR="u2fd/g2f_tools"

inherit cros-workon platform

DESCRIPTION="G2F gnubby (U2F+GCSE) development and testing tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/u2fd"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/u2fd:=
	dev-libs/hidapi:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/protofiles:=
	chromeos-base/system_api:=
"

platform_pkg_test() {
	platform test_all
}
