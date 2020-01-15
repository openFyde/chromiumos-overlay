# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="d790111f8e619bd13475926482aacf996a776446"
CROS_WORKON_TREE="64f2aac110f660f0cd3d9cd8c1c20f77f24132b4"
CROS_WORKON_PROJECT="chromiumos/third_party/aver-updater"

inherit cros-workon libchrome udev user

DESCRIPTION="AVer firmware updater"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/aver-updater"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
"

src_configure() {
	# Disable tautological-compare warnings, crbug.com/1042142
	append-flags "-Wno-tautological-compare"
	cros-workon_src_configure
}

src_install() {
	dosbin aver-updater
	udev_dorules conf/99-run-aver-updater.rules
}

pkg_preinst() {
	enewuser cfm-firmware-updaters
	enewgroup cfm-firmware-updaters
}
