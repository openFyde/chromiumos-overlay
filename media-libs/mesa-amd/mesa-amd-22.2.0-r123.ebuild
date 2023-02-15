# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mesa/mesa-7.9.ebuild,v 1.3 2010/12/05 17:19:14 arfrever Exp $

EAPI=7

CROS_WORKON_COMMIT="43f66d43ae588083b0589f39914b619eb5607a9d"
CROS_WORKON_TREE="30071540b93bb9a953e7bd2ddd28666fc11bd01d"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa-amd"
CROS_WORKON_EGIT_BRANCH="chromeos-amd"

inherit flag-o-matic meson toolchain-funcs cros-workon

DESCRIPTION="The Mesa 3D Graphics Library"
HOMEPAGE="http://mesa3d.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

VIDEO_CARDS="intel amdgpu radeon freedreno llvmpipe"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS} debug libglvnd vulkan zstd"

# keep correct libdrm and dri2proto dep
# keep blocks in rdepend for binpkg
RDEPEND="
	libglvnd? ( media-libs/libglvnd )
	!libglvnd? ( !media-libs/libglvnd )
	virtual/libelf
	dev-libs/expat
	x11-libs/libdrm
	zstd? ( app-arch/zstd )
	!media-libs/mesa
"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	x11-base/xorg-proto
	x11-libs/libva
	sys-devel/llvm
"

driver_list() {
	local drivers="$(sort -u <<< "${1// /$'\n'}")"
	echo "${drivers//$'\n'/,}"
}

src_configure() {
	tc-getPROG PKG_CONFIG pkg-config

	cros_optimize_package_for_speed

	gallium_enable video_cards_llvmpipe swrast

	# ATI code
	gallium_enable video_cards_radeon r300 r600
	gallium_enable video_cards_amdgpu radeonsi

	# Freedreno code
	gallium_enable video_cards_freedreno freedreno

	if use vulkan; then
		vulkan_enable video_cards_intel intel
		vulkan_enable video_cards_amdgpu amd
	fi

	export LLVM_CONFIG=${SYSROOT}/usr/lib/llvm/bin/llvm-config-host

	emesonargs+=(
		-Dexecmem=false
		-Dglvnd=$(usex libglvnd true false)
		-Dshader-cache-default=false
		-Dglx=disabled
		-Dllvm=enabled
		-Dshared-llvm=disabled
		-Dplatforms=
		-Degl=enabled
		-Dgbm=disabled
		-Dgles1=disabled
		-Dgles2=enabled
		$(meson_feature zstd)
		-Dgallium-drivers=$(driver_list "${GALLIUM_DRIVERS[*]}")
		-Dvulkan-drivers=$(driver_list "${VULKAN_DRIVERS[*]}")
		--buildtype $(usex debug debug release)
		-Dgallium-va=enabled
		-Dva-libs-path="/usr/$(get_libdir)/va/drivers"
		-Dvideo-codecs=h264dec,h264enc,h265dec,h265enc,vc1dec
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# Remove redundant GLES headers
	rm -f "${D}"/usr/include/{EGL,GLES2,GLES3,KHR}/*.h || die "Removing GLES headers failed."

	# Set driconf option to enable S3TC hardware decompression
	insinto "/etc/"
	doins "${FILESDIR}"/drirc
}

gallium_enable() {
	if [[ $1 == -- ]] || use $1; then
		shift
		GALLIUM_DRIVERS+=("$@")
	fi
}

vulkan_enable() {
	if [[ $1 == -- ]] || use $1; then
		shift
		VULKAN_DRIVERS+=("$@")
	fi
}
