# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2db2d38b43bb1976e7dc6e220f957ef414e52770"
CROS_WORKON_TREE=("7af66dac55260dbe54518e1c164b88af55fb6af0" "8a3e86c27ace781edecf3100d378a95cc9a7b385" "641e48c8b5eebd8fca4c9c1a0c1f148f8af2d169" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	chromeos-base/metrics:=
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
