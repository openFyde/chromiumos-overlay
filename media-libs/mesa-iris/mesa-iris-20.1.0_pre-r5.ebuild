# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="07276511fb4e3697a7e9a12593d0c012254a7162"
CROS_WORKON_TREE="92fd9755aa872e1a597f7629706c44ee9375b6a9"
MESON_AUTO_DEPEND=no

CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa-iris"

KEYWORDS="*"

inherit base meson multilib flag-o-matic toolchain-funcs cros-workon

DESCRIPTION="The Mesa 3D Graphics Library"
HOMEPAGE="http://mesa3d.org/"

# Most of the code is MIT/X11.
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT SGI-B-2.0"
SLOT="0"

IUSE="debug vulkan tools"

# keep correct libdrm dep
# keep blocks in rdepend for binpkg
RDEPEND="
	dev-libs/expat
	virtual/udev
	>=x11-libs/libdrm-2.4.94
"

DEPEND="${RDEPEND}
	dev-libs/libxml2
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_configure() {
	emesonargs+=(
		-Dllvm=false
		-Ddri3=false
		-Dshader-cache=false
		-Dglx=disabled
		-Degl=true
		-Dgbm=false
		-Dgles1=false
		-Dgles2=true
		-Dshared-glapi=true
		-Ddri-drivers=
		-Dgallium-drivers=iris
		-Dgallium-vdpau=false
		-Dgallium-xa=false
		-Dplatforms=surfaceless
		-Dtools=$(usex tools intel '')
		--buildtype $(usex debug debug release)
 		-Dvulkan-drivers=$(usex vulkan intel '')
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	rm -v -rf "${ED}usr/include"
}
