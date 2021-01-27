# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="0d5c8329c95d45206518b2b0420e9045166b19db"
CROS_WORKON_TREE=("039ed44189c17a7037215fc778a6f1fcb96b1433" "b174079c2e13cf5c19f0db22828e69fcc540cded" "f272e3d49381bd4fcf240c00e1d102df0efda1ba" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
