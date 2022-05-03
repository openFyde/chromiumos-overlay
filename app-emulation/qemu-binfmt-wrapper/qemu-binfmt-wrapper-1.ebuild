# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="QEMU wrappers to preserve argv[0] when testing"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/docs/+/HEAD/testing/qemu_unit_tests_design.md"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

S=${WORKDIR}

src_compile() {
	$(tc-getCC) \
		-Wall -Wextra -Werror \
		${CFLAGS} \
		${CPPFLAGS} \
		${LDFLAGS} \
		"${FILESDIR}"/${PN}.c \
		-o ${PN} \
		-static || die
}

src_install() {
	dobin ${PN}
}
