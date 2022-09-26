# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="6cfc665c3bc82a5b3fe209153bf75cdddd398435"
CROS_WORKON_TREE=("9706471f3befaf4968d37632c5fd733272ed2ec9" "4866bedda3e3e1309466be863d80ae5dc42ffcd3" "519d3041d1234883ccf9bcf1ec2434414477b72f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml ml_benchmark .gn"

PLATFORM_SUBDIR="ml"

inherit cros-workon platform

DESCRIPTION="Command line interface to machine learning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/ml"

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
	platform_install
}

platform_pkg_test() {
	platform test_all
}
