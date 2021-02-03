# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson

DESCRIPTION="Percetto is a C wrapper for Perfetto SDK."
HOMEPAGE="https://github.com/olvaffe/percetto"

SRC_URI="https://github.com/olvaffe/percetto/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="*"
IUSE="debug"
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="
	chromeos-base/perfetto
"

src_prepare() {
	default
}

src_configure() {
	local emesonargs=(
		-Dperfetto-sdk="${SYSROOT}/usr/include/perfetto/"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
