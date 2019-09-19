# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("891a9093caa274b46b13a8e20eda1c0a23e7054c" "997cab7f3997cf3f3a970eb28cee91b0d59dcaec")
CROS_WORKON_TREE=("fc7fc7a30cc667a3d0fec5545fc6601b38b074ae" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "24fe0bae1dca0eb14f285f15c0441679cac8941b")
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
SLOT="0"
KEYWORDS="*"

DEPEND="
	chromeos-base/libbrillo
	chromeos-base/libchrome
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
