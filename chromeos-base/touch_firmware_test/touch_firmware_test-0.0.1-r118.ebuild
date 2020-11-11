# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="1db05fad101c7d99455f6e45a3637702bea8d0af"
CROS_WORKON_TREE="6fad854077ffc77d076c5dc0daf4b6814fb53fd3"
CROS_WORKON_PROJECT="chromiumos/platform/touch_firmware_test"
CROS_WORKON_LOCALNAME="platform/touch_firmware_test"

PYTHON_COMPAT=( python2_7 python3_{6..8} )
inherit cros-sanitizers cros-workon cros-constants cros-debug distutils-r1

DESCRIPTION="Chromium OS multitouch utilities"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND=""

DEPEND=${RDEPEND}

src_configure() {
	sanitizers-setup-env
	cros-debug-add-NDEBUG
	default
}

src_install() {
	# install the remote package
	distutils-r1_src_install

	# install the webplot script
	exeinto /usr/local/bin
	newexe webplot/chromeos_wrapper.sh webplot

	# install the heatmapplot script
	newexe heatmap/chromeos_heatmapplot_wrapper.sh heatmapplot

	# install to autotest deps directory for dependency
	DESTDIR="${D}${AUTOTEST_BASE}/client/deps/touchpad-tests/touch_firmware_test"
	mkdir -p "${DESTDIR}"
	echo "CMD:" cp -Rp "${S}"/* "${DESTDIR}"
	cp -Rp "${S}"/* "${DESTDIR}"
}
