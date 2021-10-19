# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="d9e56b86e59206efefdad79dab60b3d875e5f98e"
CROS_WORKON_TREE="55df972c2cb82b810bf7b4dde5b24f59f01ff79d"
CROS_WORKON_PROJECT="chromiumos/third_party/libmbim"

inherit meson cros-sanitizers cros-workon udev

DESCRIPTION="MBIM modem protocol helper library"
HOMEPAGE="http://cgit.freedesktop.org/libmbim/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="-asan doc static-libs"

RDEPEND=">=dev-libs/glib-2.36
	virtual/libgudev"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig"

src_configure() {
	sanitizers-setup-env

	local emesonargs=(
		--prefix='/usr'
		-Dmbim_username='modem'
		-Dlibexecdir='/usr/libexec'
		-Dudevdir='/lib/udev'
		-Dintrospection=false
		-Dbash_completion=false
	)
	meson_src_configure
}
