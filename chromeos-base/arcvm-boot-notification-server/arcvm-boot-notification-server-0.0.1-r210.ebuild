# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="473c4b7c5aa25eaacdd27b48f58a8a6a94b343ca"
CROS_WORKON_TREE=("c79649aa86c6e76494520006877c89b38c13feb9" "b2b5292f6e0ba99109da8bfc0fa6144f2337a857" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
