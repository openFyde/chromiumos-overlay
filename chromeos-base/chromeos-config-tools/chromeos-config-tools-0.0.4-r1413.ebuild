# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("24d2038b6981209821e6dd62b10e28124cad62be" "f087346e5d21b653cfd17d710fd1341328789f6a")
CROS_WORKON_TREE=("dea48af07754556aac092c0830de0b1ab410077b" "0f546233f238386f547a717776dbc73748832f53" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "3204e6befb8d3be4d6b246e17825c13c5f08c272" "f05a2bbb70e880ed1f83545486264212c404256f" "1fa3d4b3b918897f064e71f433dbc1186d3d6837")
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
