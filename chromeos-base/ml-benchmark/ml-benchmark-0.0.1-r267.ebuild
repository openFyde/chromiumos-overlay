# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="490b7eb728012e2e05d12cab04e2fd327a4f9d02"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "d149a130b297cbfaaa5048e406cbf45cccab0f2d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
