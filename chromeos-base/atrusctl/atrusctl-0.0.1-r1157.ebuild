# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("2d9622a624880d0b83b1ccfa21d83fc66c0e1a39" "9105f9b4dff2e298b9318937ac8eceed897dec8a")
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "57099a72dae27323bfc6e0e5d1a3e074d4db3271")
CROS_WORKON_LOCALNAME=("platform2" "third_party/atrusctl")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/third_party/atrusctl")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/atrusctl")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="atrusctl"

inherit cros-workon platform udev user

DESCRIPTION="CrOS daemon for the Atrus speakerphone"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/atrusctl/"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	virtual/libusb:1
	virtual/libudev:0=
"
RDEPEND="
	${DEPEND}
	!sys-apps/atrusctl
"

src_install() {
	platform_src_install

	dosbin "${OUT}/atrusd"

	insinto /etc/rsyslog.d
	newins conf/rsyslog-atrus.conf atrus.conf

	udev_newrules conf/udev-atrus.rules 99-atrus.rules

	insinto /etc/init
	doins init/atrusd.conf

	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.Atrusctl.conf
}

pkg_preinst() {
	enewuser atrus
	enewgroup atrus
}
