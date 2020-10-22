# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="3aa328e44839593b89e515c899945f2cf1621b54"
CROS_WORKON_TREE=("6cadd9f53ad2c518aa18312d8ea45915a3dd112a" "ee348502dccfa4f794845fafb2ca9db2075ceb24" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/boot_notification_server .gn"

PLATFORM_SUBDIR="arc/vm/boot_notification_server"

inherit cros-workon platform user

DESCRIPTION="ARCVM boot notification server"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/boot_notification_server"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"
IUSE="+seccomp"

src_install() {
	newsbin "${OUT}/boot_notification_server" arcvm_boot_notification_server

	insinto /etc/init
	doins arcvm-boot-notification-server.conf

	insinto /etc/dbus-1/system.d
	doins dbus-1/ArcVmBootNotificationServer.conf

	insinto /usr/share/policy
	use seccomp && newins "arcvm_boot_notification_server-seccomp-${ARCH}.policy" arcvm_boot_notification_server-seccomp.policy
}

platform_pkg_test() {
	platform_test "run" "${OUT}/boot_notification_server_testrunner"
}

pkg_preinst() {
	enewuser arcvm-boot-notification-server
	enewgroup arcvm-boot-notification-server
}
