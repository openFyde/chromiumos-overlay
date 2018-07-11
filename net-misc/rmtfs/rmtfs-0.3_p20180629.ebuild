# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="QMI Remote File System Server"
HOMEPAGE="https://github.com/andersson/rmtfs"
GIT_SHA1="a75ad5dc2af5251cb714a75ca07dffd18d291c47"
SRC_URI="https://github.com/andersson/rmtfs/archive/${GIT_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="asan"

DEPEND="
	net-libs/libqrtr
	virtual/udev
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GIT_SHA1}"

src_configure() {
	asan-setup-env

	# TODO(benchan): send PR to respect CFLAGS/LDFLAGS
	sed -i \
		-e '/^prefix/s:=.*:=/usr:' -e '/LDFLAGS/s/:=/+=/' -e '/^CFLAGS/d' \
		Makefile || die
}
