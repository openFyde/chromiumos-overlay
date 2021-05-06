# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="fad4105e79d9c8efb65cdcbbccc2844e587f65e3"
CROS_WORKON_TREE=("0c3ac991150c21db311300731f54e240235fb7ee" "342b6b866531740b10a35f9cf591f5980056d163" "c69864635af6d29754cf51b709bdd08dba82ea80" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
