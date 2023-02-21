# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_GO_SOURCE="github.com/google/syzkaller cf8c2d3920e29515c91e0b0797b4b432369d1a7d"

CROS_GO_PACKAGES=(
	"github.com/google/syzkaller"
)

inherit cros-go

DESCRIPTION="Syzkaller kernel fuzzer"
HOMEPAGE="https://github.com/google/syzkaller"
SRC_URI="$(cros-go_src_uri)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
SYZKALLER_PATH="src/github.com/google/syzkaller"

src_prepare() {
	cd "${SYZKALLER_PATH}" || die "unable to cd to extracted syzkaller directory"
	eapply "${FILESDIR}"/0001-cros-syzkaller-do-not-use-go.sum-and-go.mod.patch
	eapply "${FILESDIR}"/0002-cros-syzkaller-turn-off-vhci-injection.patch
	eapply "${FILESDIR}"/0003-cros-syzkaller-use-arm-toolchain-available-within-ch.patch
	eapply "${FILESDIR}"/0004-cros-syzkaller-only-do-exact-function-name-matching.patch
	eapply "${FILESDIR}"/0005-cros-syzkaller-description-updates-for-devlink-t7xx.patch
	eapply "${FILESDIR}"/0006-cros-syzkaller-do-not-unshare-CLONE_NEWNET.patch
	eapply "${FILESDIR}"/0007-cros-syzkaller-add-rawcover32-to-syz-manager.patch
	eapply_user
}

src_compile() {
	cd "${SYZKALLER_PATH}" || die "unable to cd to extracted syzkaller directory"
	# shellcheck disable=SC2154
	CFLAGS="" GO111MODULE=off GOPATH="${GOPATH}:${S}" emake TARGETOS=linux TARGETARCH="${ARCH}" || die "syzkaller build failed"
}

src_install() {
	local bin_path="${SYZKALLER_PATH}/bin"
	dobin "${bin_path}"/syz-manager
	dobin "${bin_path}"/linux_"${ARCH}"/syz-{fuzzer,executor,execprog}
}

# Overriding postinst for package github.com/google/syzkaller
# as no Go files are present in the repository root directory
# and getting list of packages inside cros-go_pkg_postinst() fails.
pkg_postinst() {
	:;
}
