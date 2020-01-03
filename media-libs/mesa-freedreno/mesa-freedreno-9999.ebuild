# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mesa/mesa-7.9.ebuild,v 1.3 2010/12/05 17:19:14 arfrever Exp $

EAPI=6

MESON_AUTO_DEPEND=no

CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa-freedreno"

if [[ ${PV} = 9999* ]]; then
	EXPERIMENTAL="true"
fi

KEYWORDS="~*"

inherit base meson multilib flag-o-matic toolchain-funcs cros-workon

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="http://mesa3d.sourceforge.net/"

# Most of the code is MIT/X11.
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT SGI-B-2.0"
SLOT="0"

IUSE="video_cards_freedreno debug vulkan"

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

src_prepare() {
	if [[ ${PV} = 9999* ]]; then
		# Produce a dummy git_sha1.h file because .git will not be copied to portage tmp directory
		echo '#define MESA_GIT_SHA1 "git-0000000"' > src/git_sha1.h
	fi

	default
}

src_configure() {
	tc-getPROG PKG_CONFIG pkg-config

	append-cppflags "-UENABLE_SHADER_CACHE"

	emesonargs+=(
		-Dllvm=false
		-Ddri3=false
		-Dglx=disabled
		-Degl=true
		-Dgbm=false
		-Dgles1=false
		-Dgles2=true
		-Dshared-glapi=true
		-Ddri-drivers=
		-Dgallium-drivers=freedreno
		-Dgallium-vdpau=false
		-Dgallium-xa=false
		-Dplatforms=surfaceless
		-Dtools=freedreno
		--buildtype $(usex debug debug release)
	)

	if use vulkan; then
		emesonargs+=( -Dvulkan-drivers=freedreno )
	else
		emesonargs+=( -Dvulkan-drivers= )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	find ${ED} -name '*kgsl*' -exec rm -f {} +
	rm -v -rf ${ED}"usr/include"
}
