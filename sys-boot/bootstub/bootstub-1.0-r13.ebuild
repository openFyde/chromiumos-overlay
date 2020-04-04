# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e69fbecd355bf860f4bf165fb83abb354e513fa8"
CROS_WORKON_TREE="5dc2522a0362afc0478513116e6f09f15efb9986"
CROS_WORKON_PROJECT="chromiumos/third_party/bootstub"

inherit eutils toolchain-funcs cros-workon

DESCRIPTION="Chrome OS embedded bootstub"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""
DEPEND="sys-boot/gnu-efi"

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
