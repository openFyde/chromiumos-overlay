# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("0db2a85507921f4728dde02e0bd064884e65ee94" "74ce834cb73768e49e1acecabfb2f43ab19e4257")
CROS_WORKON_TREE=("4fdfdbe461ccedeaaf176391c0bbb0f74943be45" "2c293b25dd09e3deae29a0dd7d637fbc1cc44597" "d412777ea93d8e60e2132206bcadc9e03f2a09e9" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "8a538cd4c7bf0e061769dee7d0a7bd6d2f4f5c2c" "9e4d851d5f49d3ff4dd1b7b8a0f59b2650d3242f")
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
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/chromeos-config"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE=""

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
	dosbin "${OUT}"/cros_configfs

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
	# Run this here since we may not run cros_config_main_test.
	./chromeos-config-test-setup.sh
	local tests=(
		fake_cros_config_test
		cros_config_test
		cros_config_main_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
	./run_tests.sh || die "cros_config unit tests have errors"
}
