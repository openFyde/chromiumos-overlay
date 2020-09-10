# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="f1d892b43c2170b8960364f75585484ed0a4448f"
CROS_WORKON_TREE=("b2d7995ab106fbf61493d108c2bfd78d1a721d83" "a168325216d22eca49bd5430736299e318967f42" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
