# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Serve an archive or compressed file as a FUSE file system"
HOMEPAGE="https://github.com/google/fuse-archive"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	app-arch/libarchive:=
	sys-fs/fuse:0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	# As of version 0.1.2 (September 2021), upstream fuse-archive does not have
	# a "configure" step, only "make install". The Makefile's default prefix is
	# "/usr/local" but cros-disks can't exec "/usr/local/bin/fuse-archive". We
	# explicitly set prefix="/usr" here.
	sed -i -e 's,prefix=/usr/local,prefix=/usr,' Makefile || die
}
