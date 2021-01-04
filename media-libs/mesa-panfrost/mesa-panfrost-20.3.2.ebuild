# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/mesa"
CROS_WORKON_COMMIT="b3877e880ba9d75a993e3fd394b03f4d19c2e17c"
CROS_WORKON_TREE="02503301daef244eb54dfe159f0d795d31064aa1"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa"
CROS_WORKON_MANUAL_UPREV="1"
CROS_WORKON_EGIT_BRANCH="mesa-20.3"

KEYWORDS="*"

inherit base meson flag-o-matic cros-workon

DESCRIPTION="The Mesa 3D Graphics Library"
HOMEPAGE="http://mesa3d.org/"

# Most of the code is MIT/X11.
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT SGI-B-2.0"

IUSE="debug vulkan"

COMMON_DEPEND="
	dev-libs/expat:=
	>=x11-libs/libdrm-2.4.94:=
"

RDEPEND="${COMMON_DEPEND}
"

DEPEND="${COMMON_DEPEND}
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_configure() {
	emesonargs+=(
		-Dllvm=disabled
		-Ddri3=disabled
		-Dshader-cache=disabled
		-Dglx=disabled
		-Degl=enabled
		-Dgbm=disabled
		-Dgles1=disabled
		-Dgles2=enabled
		-Dshared-glapi=enabled
		-Ddri-drivers=
		-Dgallium-drivers=panfrost
		-Dgallium-vdpau=disabled
		-Dgallium-xa=disabled
		-Dplatforms=
		-Dtools=panfrost
		--buildtype $(usex debug debug release)
		-Dvulkan-drivers=$(usex vulkan panfrost '')
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	rm -v -rf "${ED}/usr/include"
}
