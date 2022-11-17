# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="cabaaf3463b91aa8a977c889d325b1b25daac030"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "e2559c08f64eac3981688081d4fdca0614ba892b" "c685b2ed29c061e61a563c198ef3cbbf2f1012d5" "db75597a3a702c90030f8f50dee1f1f79046be1a" "52a37fd272cac406117fc0fe310a1518197b40f9" "310b96c5a5e6797857fc68c5850211192cb1ec95" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation metrics trunks u2fd .gn"

PLATFORM_SUBDIR="u2fd"

inherit cros-workon platform

DESCRIPTION="G2F gnubby (U2F+GCSE) development and testing tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/u2fd"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="cr50_onboard ti50_onboard"

COMMON_DEPEND="
	chromeos-base/libhwsec:=
	dev-libs/hidapi:=
	"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/u2fd:=
	"

platform_pkg_test() {
	platform test_all
}
