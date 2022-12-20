# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2024c47f3cea15401fe53a34e6140993777bcbcb"
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "34a351a81cfca5a4c7376390643a1ea778c2dab0" "df143cde88af1b7e2427d71c8519156768a0ef36" "8d856cb1fd8b7169075c5ae9c9a1ed9d4b8cbd6b" "6de49d0bc794fced41130308586470b1f89d76ab" "f874db96c12b1f01104bf43cac53d49ac8ab8335" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
IUSE="cr50_onboard profiling ti50_onboard"

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
