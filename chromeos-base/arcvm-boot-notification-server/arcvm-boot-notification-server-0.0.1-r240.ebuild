# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="63f953f3f1b9573ebcdbae9c1dd27322654b94a5"
CROS_WORKON_TREE=("b9732f2bc7bbc922b1abb9212879b987c70537a8" "88e843cfa45c09f42d875d1276aa8c51d84540c6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
