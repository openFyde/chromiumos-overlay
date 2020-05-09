# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4660a3536a55f3c2ec19cab48e6380ba8defeede"
CROS_WORKON_TREE="1f56258ddfa8ff9db44a062bfbb178e06ed24fd0"
CROS_WORKON_PROJECT="chromiumos/third_party/aver-updater"

inherit cros-workon cros-common.mk libchrome udev user

DESCRIPTION="AVer firmware updater"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/aver-updater"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
"

DEPEND="${RDEPEND}"

src_configure() {
	# Disable tautological-compare warnings, crbug.com/1042142
	append-cppflags "-Wno-tautological-compare"
	cros-common.mk_src_configure
	default
}

src_install() {
	dosbin "${OUT}/aver-updater"
	udev_dorules conf/99-run-aver-updater.rules
}

pkg_preinst() {
	enewuser cfm-firmware-updaters
	enewgroup cfm-firmware-updaters
}
