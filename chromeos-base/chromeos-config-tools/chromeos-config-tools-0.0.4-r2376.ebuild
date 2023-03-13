# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("325a58e54f5411f7df403afb3c9de45406af2601" "e70acdbc2d6c809eb800b039fea819600e1259c7")
CROS_WORKON_TREE=("e25747d84e1e5bb28342114bcceca2f823218dbc" "3f8a9a04e17758df936e248583cfb92fc484e24c" "e2d936f5530be9fdd0daca1449370623d61d8c4a" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "d08add5e646ad8d8fcc045e44a9eca5a03567a55" "75bcb06ec76a524531b10259ace72bdac2213f00")
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

RDEPEND="
	!unibuild? ( sys-apps/mosys )
"

DEPEND="${RDEPEND}"

src_install() {
	platform_src_install

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
