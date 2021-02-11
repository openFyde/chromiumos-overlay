# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="90cf35cfa53eb7bb14d23947c21f5587e3473a7a"
CROS_WORKON_TREE=("6aefce87a7cf5e4abd0f0466c5fa211f685a1193" "504f2766c25f253283ff1e0827168d40e3e370a9" "35ed88b1d5af84e64e2d3eff70180c5f9bbadaca" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

RDEPEND="
	dev-libs/protobuf:=
"
DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=
	chromeos-base/vm_protos:=
"

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
