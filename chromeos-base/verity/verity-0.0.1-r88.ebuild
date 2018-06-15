# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="9b364b377ae1d6a1588d8b34c71db7e5f0cd8fdb"
CROS_WORKON_TREE="225f0890ce089261dddb6aaaf884a24312a9580d"
CROS_WORKON_PROJECT="chromiumos/platform/dm-verity"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon

DESCRIPTION="File system integrity image generator for Chromium OS"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="valgrind"

RDEPEND=""

# qemu use isn't reflected as it is copied into the target
# from the build host environment.
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gmock
		dev-cpp/gtest
	)
	valgrind? ( dev-util/valgrind )"

src_prepare() {
	cros-workon_src_prepare
}

src_configure() {
	cros-workon_src_configure
}

src_compile() {
	cros-workon_src_compile
}

src_test() {
	! use amd64 && ! use x86 && ewarn "Skipping unittests for non-x86" && return 0
	cros-workon_src_test
}

src_install() {
	cros-workon_src_install
	dolib.a "${OUT}"/libdm-bht.a
	insinto /usr/include/verity
	doins dm-bht.h dm-bht-userspace.h
	insinto /usr/include/verity
	cd include
	doins -r linux asm asm-generic crypto
	cd ..
	into /
	dobin "${OUT}"/verity-static
	dosym verity-static bin/verity
}
