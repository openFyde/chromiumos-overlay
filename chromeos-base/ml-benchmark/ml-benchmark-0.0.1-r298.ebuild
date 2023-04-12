# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="410f3d5e668f715073f98e01459b5bcffaf65ab8"
CROS_WORKON_TREE=("8fad85aa9518e1a0f04272ae9e077c4a4036297d" "9ba045590a286ea0a402f35c72f261c4892e4a07" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml_benchmark .gn"

DESCRIPTION="Chrome OS ML Benchmarking Suite"

PLATFORM_SUBDIR="ml_benchmark"

inherit cros-workon platform

# chromeos-base/ml_benchmark blocked due to package rename
RDEPEND="
	!chromeos-base/ml_benchmark
	vulkan? ( media-libs/clvk )
"

DEPEND="${RDEPEND}
	dev-libs/protobuf:=
"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="vulkan"

platform_pkg_test() {
	platform test_all
}
