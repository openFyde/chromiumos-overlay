# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3f55c5cffebdd0632fafa010ca928c369d79363d"
CROS_WORKON_TREE="239ab37d79ffa4f9ab10ffb0f28e3c0637876284"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa-freedreno"
CROS_WORKON_EGIT_BRANCH="chromeos-freedreno"

KEYWORDS="*"

inherit base meson flag-o-matic cros-workon

DESCRIPTION="The Mesa 3D Graphics Library"
HOMEPAGE="http://mesa3d.org/"

# Most of the code is MIT/X11.
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT SGI-B-2.0"

IUSE="debug vulkan libglvnd perfetto zstd"

COMMON_DEPEND="
	dev-libs/expat:=
	>=x11-libs/libdrm-2.4.94:=
"

RDEPEND="${COMMON_DEPEND}
	libglvnd? ( media-libs/libglvnd )
	!libglvnd? ( !media-libs/libglvnd )
	zstd? ( app-arch/zstd )
"

DEPEND="${COMMON_DEPEND}
	perfetto? ( >=chromeos-base/perfetto-29.0 )
"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_configure() {
	emesonargs+=(
		-Dexecmem=false
		-Dglvnd=$(usex libglvnd true false)
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
		-Dgallium-drivers=freedreno
		-Dgallium-vdpau=disabled
		-Dgallium-xa=disabled
		-Dperfetto=$(usex perfetto true false)
		$(meson_feature zstd)
		-Dplatforms=
		-Dtools=freedreno
		--buildtype $(usex debug debug release)
		-Dvulkan-drivers=$(usex vulkan freedreno '')
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	find "${ED}" -name '*kgsl*' -exec rm -f {} +
	rm -v -rf "${ED}/usr/include"
}
