# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual package for listing toolchain packages.
All packages which should be considered part of the toolchain must be directly
listed as dependencies of this package. The common features of packages that
should be in this virtual are packages that consumed by many other packages (to
the point of needing to rebuild a significant chunk of the world to properly
test changes) and that don't fit nicely in to Portage's dependency model (for
bootstrap problems/circular dependencies/other reasons)."
HOMEPAGE="http://dev.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""


# dev-lang/rust qualifies as a toolchain package by the above criteria but
# cannot be tested in a straightforward manner on the CQ because it requires
# the full suite of cross-compilers to be built in order to be compiled. It can
# be added back to this list once it can be compiled without requiring every
# cross-compiler to be built first.

DEPEND="
	dev-lang/go
	dev-libs/elfutils
	sys-devel/binutils
	sys-devel/gcc
	sys-devel/llvm
	sys-kernel/linux-headers
	sys-libs/compiler-rt
	sys-libs/glibc
	sys-libs/libcxx
	sys-libs/libcxxabi
	sys-libs/llvm-libunwind
"


src_compile() {
	die "This package is for information only and should never be installed."
}