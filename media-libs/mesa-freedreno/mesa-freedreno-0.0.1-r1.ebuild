# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mesa/mesa-7.9.ebuild,v 1.3 2010/12/05 17:19:14 arfrever Exp $

EAPI=5

CROS_WORKON_COMMIT="3e905052248a6e9c0e1ce6b7f32ad5aeff28a7c8"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa"
CROS_WORKON_BLACKLIST="1"

if [[ ${PV} = 9999* ]]; then
	EXPERIMENTAL="true"
fi

KEYWORDS="*"

inherit base autotools multilib flag-o-matic python toolchain-funcs cros-workon

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
	=dev-lang/python-2*
	dev-libs/libxml2
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_prepare() {
	base_src_prepare

	if [[ ${PV} = 9999* ]]; then
		# Produce a dummy git_sha1.h file because .git will not be copied to portage tmp directory
		echo '#define MESA_GIT_SHA1 "git-0000000"' > src/git_sha1.h
	fi

	eautoreconf
}

src_configure() {
	tc-getPROG PKG_CONFIG pkg-config

	# Needs std=gnu++11 to build with libc++. crbug.com/750831
	append-cxxflags "-std=gnu++11"

	if use vulkan; then
		VULKAN_DRIVERS="freedreno"
	fi

	append-flags "-UENABLE_SHADER_CACHE"

	econf \
		--disable-option-checking \
		--enable-texture-float \
		--disable-dri3 \
		--disable-glx \
		--disable-gbm \
		--disable-gles1 \
		--enable-gles2 \
		--enable-shared-glapi \
		$(use_enable debug) \
		--with-dri-drivers= \
		--with-gallium-drivers=freedreno \
		--with-vulkan-drivers=${VULKAN_DRIVERS} \
		--with-egl-platforms=surfaceless
}

src_install() {
	base_src_install

	find ${ED} -name '*kgsl*' -exec rm -f {} +
	rm -v -rf ${ED}"usr/include"
}
