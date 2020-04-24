# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("a197b230231fa1ccbc313c6fbd373154690f068d" "2b95f964b87330517fe03519007fac8b5ebde8a8")
CROS_WORKON_TREE=("2b7b46ab1083cdcc8b17bd7f5b05ddff336b0559" "4197a180fa93795924946293a634caca6b50cc0c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "9d9f581afefb886d186545e8167334b1adcb3d46" "8384d2163b9add5b030c9489a731d81d1c5bc725" "f58222205553f9b0aff49059be087302ac272c20")
CROS_WORKON_INCREMENTAL_BUILD=1

CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"chromiumos/config"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
	"config"
)
CROS_WORKON_SUBTREE=(
	"common-mk chromeos-config .gn power_manager"
	"python test"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/config"
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
