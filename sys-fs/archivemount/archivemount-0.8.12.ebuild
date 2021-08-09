# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Mount archives using libarchive and FUSE"
HOMEPAGE="https://www.cybernoia.de/software/archivemount.html https://github.com/cybernoid/archivemount"
SRC_URI="https://www.cybernoia.de/software/archivemount/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	app-arch/libarchive:=
	sys-fs/fuse:0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# The upstream repository (https://github.com/cybernoid/archivemount) does not
# use git tags for e.g. its 0.8.12 release. These patches started from
# https://github.com/cybernoid/archivemount/commit/321ded82f60c0d40278381365f8f84de82930cb0
# committed on March 2018, the latest commit (as of 2021-07-01) that modified
# the "0.8.12" section of the CHANGELOG file in that github repo. That commit's
# archivemount.c file matches the one extracted from
# https://www.cybernoia.de/software/archivemount/archivemount-0.8.12.tar.gz
#
# $ ls -l archivemount.c
# -rwxr-x--- 1 nigeltao primarygroup 70673 Mar 28  2018 archivemount.c
# $ sha256sum archivemount.c
# 2835d91544f6e1a9f07475b4b729262da8dd8d96402052fa51cfbd43268b4455  archivemount.c
PATCHES=(
	# https://github.com/cybernoid/archivemount/pull/20
	"${FILESDIR}/archivemount-0.8.12-dev-fd.patch"
	# https://github.com/cybernoid/archivemount/pull/18
	"${FILESDIR}/archivemount-0.8.12-raw-pathname.patch"
	# https://github.com/cybernoid/archivemount/pull/19
	"${FILESDIR}/archivemount-0.8.12-fchdir.patch"
)

src_prepare() {
	default

	# https://bugs.gentoo.org/725998
	sed -i -e 's/CFLAGS=//g' configure.ac || die
	eautoreconf
}
