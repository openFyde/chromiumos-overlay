# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("c7155fb24a44895f4b829a79e8f94e95393076a6" "c5e72856a12e3157ab4d79b98614d3bdf9c2b949")
CROS_WORKON_TREE=("4fdfdbe461ccedeaaf176391c0bbb0f74943be45" "e96c7b05f7b481bedb62e65f6e9a177306f1b5b2" "be685e50cd6402b6c71b394cbc9798b07b526ef1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "6589ce6727da4a5885867220ab67ee540c2db405" "f87095b8c1a06b38a8fe4183b31cdf15821ac9a1")
CROS_WORKON_INCREMENTAL_BUILD=1

CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"chromiumos/platform/dev-util"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
	"platform/dev"
)
CROS_WORKON_SUBTREE=(
	".clang-format common-mk chromeos-config .gn power_manager"
	"test/gtest"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform/dev"
)
PLATFORM_SUBDIR="chromeos-config"

inherit cros-workon platform gtest

DESCRIPTION="Chrome OS configuration tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/chromeos-config"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE="unibuild"

GTEST_METADATA=(
	libcros_config/cros_config_functional_test.yaml
)

GTEST_TEST_INSTALL_DIR="/usr/local/gtest/cros_config"

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
	dolib.so "${OUT}/lib/libcros_config.so"

	insinto "/usr/include/chromeos/chromeos-config/libcros_config"
	doins "${S}"/libcros_config/*.h

	"${S}"/platform2_preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libcros_config.pc

	insinto "/usr/include/cros_config"
	doins "libcros_config/cros_config_interface.h"
	doins "libcros_config/cros_config.h"
	doins "libcros_config/fake_cros_config.h"

	dobin "${OUT}"/cros_config
	newbin cros_config_mock.sh cros_config_mock

	if use unibuild; then
		newsbin scripts/cros_config_setup.sh cros_config_setup
	else
		newsbin scripts/cros_config_setup_legacy.sh cros_config_setup
	fi

	if use test; then
		exeinto "${GTEST_TEST_INSTALL_DIR}"
		doexe  "${OUT}/cros_config_functional_test"

		install_gtest_metadata "${GTEST_METADATA[@]}"
	fi

	# Install init scripts.
	insinto /etc/init
	doins init/*.conf
}

platform_pkg_test() {
	local tests=(
		fake_cros_config_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
	./run_tests.sh || die "cros_config unit tests have errors"
}
