# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="61ec7b6c83df3c40e70beef2582357189061f820"
CROS_WORKON_TREE=("9706471f3befaf4968d37632c5fd733272ed2ec9" "0aaa9dd065714d684a9e8a78f6df947048683283" "eb510d666a66e6125e281499b649651b849a25f7" "0744892ba40d23c2672468cfb7f5e3550d8644a5" "47c8534da455fadba08af802cb41ab22d1b481ce" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec metrics trunks u2fd .gn"

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
