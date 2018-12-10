# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="df4b06f91cc3de2ae6e4394431f038b1daab1bb8"
CROS_WORKON_TREE=("5bd6cd9b9f9aeb7b7134f50089b6b616d216c60f" "26a01e07ce554b2b17ce020584cf40c3584ccb1a" "eee5d89cc61c5f75b2e6fa9e17f0c3b9411528e1" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk u2fd trunks .gn"

PLATFORM_SUBDIR="u2fd"

inherit cros-workon platform

DESCRIPTION="G2F gnubby (U2F+GCSE) development and testing tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/u2fd"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	dev-libs/hidapi
	"

DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-ec-headers
	"

src_install() {
	dobin "${OUT}"/g2ftool
}

platform_pkg_test() {
	platform_test "run" "${OUT}/g2f_client_test"
}
