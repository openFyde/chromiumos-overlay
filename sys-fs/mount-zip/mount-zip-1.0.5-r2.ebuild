# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cros-sanitizers

DESCRIPTION="FUSE file system for ZIP archives"
HOMEPAGE="https://github.com/google/mount-zip"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	>=chromeos-base/chrome-icu-89
	dev-libs/libzip:=
	sys-fs/fuse:0"

DEPEND="${RDEPEND}
	dev-libs/boost"

BDEPEND="
	virtual/pkgconfig"

DOCS=( changelog README.md )

PATCHES=(
	"${FILESDIR}/${PN}-1.0.2-chrome-icu.patch"
	"${FILESDIR}/${PN}-1.0.5-algorithm.patch"
)

src_compile() {
	sanitizers-setup-env
	default
}
