# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="855248a9bd9678de4f8b2a61eba2349e10289797"
CROS_WORKON_TREE=("f834e7e40228b458c4100226f262117a9d85cdb3" "9ba045590a286ea0a402f35c72f261c4892e4a07" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
