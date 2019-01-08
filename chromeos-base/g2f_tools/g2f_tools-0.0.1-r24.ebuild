# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="a54a478cd404d096c28400fd56954c85f13b9e64"
CROS_WORKON_TREE=("835c406279da5a5f4045104ee8db04529caead57" "26a01e07ce554b2b17ce020584cf40c3584ccb1a" "5b8137d491bab51a54b7c52827f4d38b70895cf3" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
