# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e1136864b979876f04722d251d65bc1cd6b8b1fd"
CROS_WORKON_TREE=("5d60482b48f8f1830a6ee93a1eccf295fd3bd41a" "b0fe85ad5ff3184f64e9c0242026f30db677c363" "20d593bc4f76d08b642ac2d57ed2f4f9af04ce50" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml ml_benchmark .gn"

PLATFORM_SUBDIR="ml"

inherit cros-workon platform

DESCRIPTION="Command line interface to machine learning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/ml"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"
IUSE="internal"

RDEPEND="
	chromeos-base/chrome-icu:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/ml:=
	sci-libs/tensorflow:=
"

DEPEND="
	${RDEPEND}
"

src_install() {
	dobin "${OUT}"/ml_cmdline
}

platform_pkg_test() {
	platform_test "run" "${OUT}/ml_cmdline_test"
}
