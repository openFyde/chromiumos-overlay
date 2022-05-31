# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ce31daf96ba1a8764dfc1e935321b9867fdd8cfa"
CROS_WORKON_TREE=("e8200272d6283e7db5bd02f4007275ee41126c5a" "12bbd542247aac252e1e4d9715c0cef094bb7b4c" "7226e3910790963c0810793db376ae53c9a32be5" "8d334e13ee768ae278f11b187eb68d647931dea3" "79ca3f650e7176da7bdb47c12e72f2c87efc2bf3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
