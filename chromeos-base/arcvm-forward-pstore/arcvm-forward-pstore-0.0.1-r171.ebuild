# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="e88fec6d3699a021360a88eef2dc17e6ba73e2db"
CROS_WORKON_TREE=("49ec0cc074e4fe5ad441f01547361a8f211118fa" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "342b6b866531740b10a35f9cf591f5980056d163" "7ef75a42aba67052842459f221271e681184cc89" "c1bde153626532428bf7409bc0597e79452c5eb8")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM2_PATHS=(
	common-mk
	.gn

	arc/vm/forward-pstore

	vm_tools/BUILD.gn
	vm_tools/common
)
CROS_WORKON_SUBTREE="${PLATFORM2_PATHS[*]}"

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
