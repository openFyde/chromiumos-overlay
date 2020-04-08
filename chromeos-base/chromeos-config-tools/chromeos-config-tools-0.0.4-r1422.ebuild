# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("e19d67ddbe2ea6dee373dfd9d05b79d01df27a8a" "e04a1ae4c80a9568ead1d966b39b61772c5cda58")
CROS_WORKON_TREE=("473665059c4645c366e7d3f0dfba638851176adc" "808920939cd1508899019e63be35368132bdd9f3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "3c06b09ff99205e8169df56b6b9f4e7cf8ed2560" "7b39269fbf100d5694714a910e004c1c67600080" "7bf6887f152110aa7efb4a5e7a3a54caf1be705c")
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
