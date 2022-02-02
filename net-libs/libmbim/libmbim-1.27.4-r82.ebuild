# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="cabfa3546d5c74a0db6b35b97a14fd2aae80e8ef"
CROS_WORKON_TREE="dafdde6c2fdba3df8ee15547c355b67c553246e6"
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
		-Dman=false
		-Dbash_completion=false
	)
	meson_src_configure
}
