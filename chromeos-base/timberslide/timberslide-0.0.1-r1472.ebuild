# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="954d3c5af0e3fb84c003213beee7bdf166373fe4"
CROS_WORKON_TREE=("abc7e8d3093049ed5a5825a5630870b13d1ad4d2" "1246968691dbebaf635601040379a2f838a46f3c" "fbf7f92e42436fc44261472202d13912ed3e8103" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(https://crbug.com/809389)
CROS_WORKON_SUBTREE="common-mk metrics timberslide .gn"

PLATFORM_SUBDIR="timberslide"

inherit cros-workon platform

DESCRIPTION="EC log concatenator for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/timberslide/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	dev-libs/re2:=
"

DEPEND="${RDEPEND}"

src_install() {
	dobin "${OUT}/timberslide"

	# Install upstart configs and scripts
	insinto /etc/init
	doins init/*.conf
	exeinto /usr/share/cros/init
	doexe init/*.sh
}

platform_pkg_test() {
	platform_test "run" "${OUT}/timberslide_test_runner"
}
