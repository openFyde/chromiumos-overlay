# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="5b3076361108e1a82da80145ef54b081343256f5"
CROS_WORKON_TREE=("b22d37072ba4d5aec5ad10140a826f42281ddd3e" "4e0ddb2b23415609990f5c84ac3e587155a6cdf5" "9ba045590a286ea0a402f35c72f261c4892e4a07" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	chromeos-base/system_api:=
	dev-libs/marisa-aosp:=
	dev-libs/libutf:=
"

platform_pkg_test() {
	platform test_all
}
