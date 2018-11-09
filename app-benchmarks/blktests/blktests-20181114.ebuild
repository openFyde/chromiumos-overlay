# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs

DESCRIPTION="Block tests suite"
HOMEPAGE="https://github.com/osandov/blktests"
GIT_REV="0d373624a05f1a86d84cd40871b34c3d5e90d06a"
SRC_URI="https://github.com/osandov/blktests/archive/${GIT_REV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="static"

DEPEND=""

RDEPEND="sys-fs/e2fsprogs
	sys-block/blktrace
	sys-block/fio
	sys-fs/xfsprogs
"

S="${WORKDIR}/${PN}-${GIT_REV}/"

src_configure() {
	use static && append-ldflags -static
	tc-export CC
	export prefix=/usr
}
