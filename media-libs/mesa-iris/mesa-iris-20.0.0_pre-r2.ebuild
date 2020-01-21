# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="28eb481bc2156ccc07c106ab517c2a3a42a53de1"
CROS_WORKON_TREE="74fadd5adb18f8a32674ff406a2bfdf9cbcc6d6b"
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
	dev-libs/libgcrypt
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
 		-Dvulkan-drivers=$(usex vulkan intel '')
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	rm -v -rf "${ED}usr/include"
}
