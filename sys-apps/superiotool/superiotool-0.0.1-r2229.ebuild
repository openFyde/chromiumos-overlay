# Copyright 2010 Chromium OS Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
CROS_WORKON_COMMIT="c4ea7caba6a23f268734606c06cf940a1d991491"
CROS_WORKON_TREE="b2fdcdc4faafe927d42faf18179e2549d1bd141f"
CROS_WORKON_PROJECT="chromiumos/third_party/coreboot"
CROS_WORKON_LOCALNAME="coreboot"

inherit cros-workon toolchain-funcs

DESCRIPTION="Superiotool allows you to detect which Super I/O you have on your mainboard, and it can provide detailed information about the register contents of the Super I/O."
HOMEPAGE="http://www.coreboot.org/Superiotool"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-apps/pciutils"
DEPEND="${RDEPEND}"

src_compile() {
	emake -C util/superiotool CC="$(tc-getCC)"
}

src_install() {
	emake -C util/superiotool DESTDIR="${D}" install
}
