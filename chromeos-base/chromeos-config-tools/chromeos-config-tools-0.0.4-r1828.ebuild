# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="9b047496376ba3c5780eda59510aaa3549d3558c"
CROS_WORKON_TREE=("4fdfdbe461ccedeaaf176391c0bbb0f74943be45" "6b82b37113f6969a6645e19dabaeda0cb4e502d5" "36a7add9183037f0a2433b9d4a4693afc7cdf356" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "cbca12da76a31b6eb156c03270eaa47a45264fc7")
CROS_WORKON_INCREMENTAL_BUILD=1

CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
)
CROS_WORKON_SUBTREE=(
	".clang-format common-mk chromeos-config .gn power_manager"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
)
PLATFORM_SUBDIR="chromeos-config"

inherit cros-workon platform

DESCRIPTION="Chrome OS configuration tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/chromeos-config"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE=""

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
		exeinto "/usr/local/gtest/cros_config"
		doexe  "${OUT}/cros_config_functional_test"
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
