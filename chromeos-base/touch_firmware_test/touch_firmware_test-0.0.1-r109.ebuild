# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="8b455f6fe6b82cf679de9a9b7379147c33025998"
CROS_WORKON_TREE="edd1d370979b8a0bb942fd9dfb62de140741f345"
CROS_WORKON_PROJECT="chromiumos/platform/touch_firmware_test"

PYTHON_COMPAT=( python2_7 )
inherit cros-sanitizers cros-workon cros-constants cros-debug distutils-r1

DESCRIPTION="Chromium OS multitouch utilities"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND=""

DEPEND=${RDEPEND}

src_prepare() {
	cros-workon_src_prepare
}

src_configure() {
	sanitizers-setup-env
	cros-workon_src_configure
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
