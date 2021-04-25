# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="16649bc6f957056315c855a66d7c780b0a07439e"
CROS_WORKON_TREE="d87f32f8d78551e3410f38cafaa5a0ac2c53c800"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa-iris"
CROS_WORKON_EGIT_BRANCH="chromeos-iris"

KEYWORDS="*"

inherit base meson flag-o-matic cros-workon

DESCRIPTION="The Mesa 3D Graphics Library"
HOMEPAGE="http://mesa3d.org/"

# Most of the code is MIT/X11.
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT SGI-B-2.0"

IUSE="debug vulkan tools"

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
		-Dgallium-drivers=iris
		-Dgallium-vdpau=disabled
		-Dgallium-xa=disabled
		# Set platforms empty to avoid the default "auto" setting. If
		# platforms is empty meson.build will add surfaceless.
		-Dplatforms=''
		-Dtools=$(usex tools intel '')
		--buildtype $(usex debug debug release)
 		-Dvulkan-drivers=$(usex vulkan intel '')
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	rm -v -rf "${ED}/usr/include"
}
