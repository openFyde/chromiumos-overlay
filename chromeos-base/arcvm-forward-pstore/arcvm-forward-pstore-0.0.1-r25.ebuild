# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="3b6509662df140ad1f2f479d046ad822b2151c72"
CROS_WORKON_TREE=("c9de2eb52379383658eaf7cbc29fdb5d8d32eb98" "fbd3e931f69a0bf810c1f26f1aa1368486c77944" "40d8c3262030e636e10056a5e180e62c423fdea1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/forward-pstore vm_tools .gn"

PLATFORM_SUBDIR="arc/vm/forward-pstore"

inherit cros-workon platform

DESCRIPTION="Forwards pstore file for ARCVM after upgrade."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/forward-pstore"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"
IUSE="+seccomp"

src_install() {
	newsbin "${OUT}/arcvm-forward-pstore" arcvm-forward-pstore

	insinto /etc/init
	doins arcvm-forward-pstore.conf

	# Install DBUS configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.ArcVmForwardPstore.conf

	# Install seccomp policy
	insinto /usr/share/policy
	use seccomp && newins "seccomp-${ARCH}.policy" arcvm-forward-pstore-seccomp.policy
}
