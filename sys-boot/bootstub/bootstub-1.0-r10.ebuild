# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="2"
CROS_WORKON_COMMIT="6697fe6404055443d7c754b365907a0604f14111"
CROS_WORKON_TREE="2b5235a821b109c685f1f7d2f8eafe35aa2ac3fb"
CROS_WORKON_PROJECT="chromiumos/third_party/bootstub"

inherit eutils toolchain-funcs cros-workon

DESCRIPTION="Chrome OS embedded bootstub"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
DEPEND="sys-boot/gnu-efi"

src_configure() {
	cros-workon_src_configure
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" LD="$(tc-getLD)" \
              OBJCOPY="$(tc-getPROG OBJCOPY objcopy)" \
              || die "${SRCPATH} compile failed."
}

src_install() {
	LIBDIR=$(get_libdir)
	emake DESTDIR="${D}/${LIBDIR}/bootstub" install || \
              die "${SRCPATH} install failed."
}
