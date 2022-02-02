# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="8a746c4998187f63cb5c5b9aca65d09120f18e28"
CROS_WORKON_TREE="e3c86fbc701ed159634ff98c9bcde7a256bd85a3"
CROS_WORKON_PROJECT="chromiumos/third_party/libqrtr-glib"
CROS_WORKON_EGIT_BRANCH="master"

inherit meson cros-sanitizers cros-workon

DESCRIPTION="QRTR modem protocol helper library"
# TODO(andrewlassalle): replace the homepage once one is created.
HOMEPAGE="https://gitlab.freedesktop.org/mobile-broadband/libqrtr-glib"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=">=dev-libs/glib-2.36:2"
BDEPEND="virtual/pkgconfig"
DEPEND="${RDEPEND}"

src_configure() {
	sanitizers-setup-env

	local emesonargs=(
		--prefix='/usr'
		-Dlibexecdir='/usr/libexec'
		-Dgtk_doc=false
		-Dintrospection=false
	)
	meson_src_configure
}
