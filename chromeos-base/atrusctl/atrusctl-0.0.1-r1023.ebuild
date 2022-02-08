# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("4c81debf8db1e288401b6d21394154537c7fd3eb" "4f1d81ecfa86ae7570f951fe6eaac9ab2c1290d7")
CROS_WORKON_TREE=("c0c03d001677e1c1906a8cd05b4e1aa1e16bab49" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "e791cbb573288deecc226b0d77ab4583fe9f747f")
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
