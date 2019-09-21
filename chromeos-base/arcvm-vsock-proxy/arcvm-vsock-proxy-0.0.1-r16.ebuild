# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="50b30fb4ad21f001034f950415cdfaf4550c6372"
CROS_WORKON_TREE=("bf84a23a00350764b97d4ceb2bee5c17164d7855" "1b96a6d1b8ce922b6e77674e08cbae9997b711c2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/vsock_proxy .gn"

PLATFORM_SUBDIR="arc/vm/vsock_proxy"

inherit cros-workon platform

DESCRIPTION="ARCVM vsock proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/vsock_proxy"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
	dev-libs/protobuf:=
	sys-fs/fuse
"

DEPEND="
	${RDEPEND}
"

# Previously this ebuild was named "arcvm".
# TODO(hashimoto): Remove this blocker after a while.
RDEPEND="
	${RDEPEND}
	!chromeos-base/arcvm
"

src_install() {
	newbin "${OUT}"/server_proxy arcvm_server_proxy

	insinto /etc/init
	doins init/arcvm-server-proxy.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/vsock_proxy_test"
}
