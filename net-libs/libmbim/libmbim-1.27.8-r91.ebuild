# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="35164f3cf2aa66ad06cbc3ef490ed5e1e0a81d1f"
CROS_WORKON_TREE="d08710491c81c1a61bb9adf5405d0deaadf0d0c5"
CROS_WORKON_PROJECT="chromiumos/third_party/libmbim"
CROS_WORKON_EGIT_BRANCH="master"

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
		-Dman=false
		-Dbash_completion=false
	)
	meson_src_configure
}
