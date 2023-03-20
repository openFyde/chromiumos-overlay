# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="94ff0b47296be87d2b33f621de220745daca4848"
CROS_WORKON_TREE=("017dc03acde851b56f342d16fdc94a5f332ff42e" "5822ccbbf029cc90675c94f8ee0f8e95530f408e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/boot_notification_server .gn"

PLATFORM_SUBDIR="arc/vm/boot_notification_server"

inherit cros-workon platform user

DESCRIPTION="ARCVM boot notification server"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/boot_notification_server"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"
IUSE="+seccomp"

src_install() {
	platform_src_install

	newsbin "${OUT}/boot_notification_server" arcvm_boot_notification_server

	insinto /etc/init
	doins arcvm-boot-notification-server.conf

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
