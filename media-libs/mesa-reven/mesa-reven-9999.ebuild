# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MESON_AUTO_DEPEND=no

EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/mesa"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_EGIT_BRANCH="chromeos-reven"
CROS_WORKON_LOCALNAME="mesa-reven"

inherit base flag-o-matic meson toolchain-funcs ${GIT_ECLASS} cros-workon

DESCRIPTION="The Mesa 3D Graphics Library"
HOMEPAGE="http://mesa3d.org/"

# Most of the code is MIT/X11.
# ralloc is LGPL-3
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT LGPL-3 SGI-B-2.0"
KEYWORDS="~*"

INTEL_CARDS="intel iris"
RADEON_CARDS="amdgpu radeon"
VIDEO_CARDS="${INTEL_CARDS} ${RADEON_CARDS} freedreno llvmpipe mach64 mga nouveau r128 radeonsi savage sis softpipe tdfx via virgl vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	+classic debug dri egl +gallium -gbm gles1 gles2
	kvm_guest llvm +nptl pic selinux shared-glapi vulkan wayland xlib-glx zstd
	libglvnd"

REQUIRED_USE="video_cards_amdgpu? ( llvm )
	video_cards_llvmpipe? ( llvm )"

COMMON_DEPEND="
	dev-libs/expat:=
	dev-libs/libgcrypt:=
	llvm? ( virtual/libelf:= )
	virtual/udev:=
	zstd? ( app-arch/zstd )
	>=x11-libs/libdrm-2.4.60:=
"

RDEPEND="${COMMON_DEPEND}
	libglvnd? ( media-libs/libglvnd:= )
"

DEPEND="${COMMON_DEPEND}
	dev-libs/libxml2:=
	x11-base/xorg-proto:=
	llvm? ( sys-devel/llvm:= )
	wayland? ( >=dev-libs/wayland-protocols-1.8:= )
"

BDEPEND="
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex
"

driver_list() {
	local drivers="$(sort -u <<< "${1// /$'\n'}")"
	echo "${drivers//$'\n'/,}"
}

src_configure() {
	tc-getPROG PKG_CONFIG pkg-config

	cros_optimize_package_for_speed
	# For llvmpipe on ARM we'll get errors about being unable to resolve
	# "__aeabi_unwind_cpp_pr1" if we don't include this flag; seems wise
	# to include it for all platforms though.
	use video_cards_llvmpipe && append-flags "-rtlib=libgcc -shared-libgcc --unwindlib=libgcc"

	if use !gallium && use !classic && use !vulkan; then
		ewarn "You enabled neither classic, gallium, nor vulkan "
		ewarn "USE flags. No hardware drivers will be built."
	fi

	if use classic; then
	# Configurable DRI drivers
		# Intel code
		dri_driver_enable video_cards_intel i965
	fi

	if use gallium; then
	# Configurable gallium drivers
		gallium_enable video_cards_llvmpipe swrast
		gallium_enable video_cards_softpipe swrast

		# Intel code
		gallium_enable video_cards_iris iris

		# Nouveau code
		gallium_enable video_cards_nouveau nouveau

		# ATI code
		gallium_enable video_cards_radeon r300 r600
		gallium_enable video_cards_amdgpu radeonsi

		gallium_enable video_cards_virgl virgl
	fi

	if use vulkan; then
		vulkan_enable video_cards_intel intel
		vulkan_enable video_cards_amdgpu amd
	fi

	LLVM_ENABLE=false
	if use llvm && use !video_cards_softpipe; then
		emesonargs+=( -Dshared-llvm=false )
		export LLVM_CONFIG=${SYSROOT}/usr/lib/llvm/bin/llvm-config-host
		LLVM_ENABLE=true
	fi

	if use kvm_guest; then
		emesonargs+=( -Ddri-search-path=/opt/google/cros-containers/lib )
	fi

	if use zstd; then
		emesonargs+=( -Dzstd=true )
	else
		emesonargs+=( -Dzstd=false )
	fi

	emesonargs+=(
		-Dglx=disabled
		-Dllvm="${LLVM_ENABLE}"
		# Set platforms empty to get only surfaceless. This works better
		# than explicitly setting surfaceless because it forces it to be
		# the default. b/206629705
		-Dplatforms=''
		-Dprefer-iris=false
		-Dshader-cache-default=false
		$(meson_feature egl)
		$(meson_feature gbm)
		$(meson_feature gles1)
		$(meson_feature gles2)
		$(meson_use selinux)
		-Ddri-drivers=$(driver_list "${DRI_DRIVERS[*]}")
		-Dgallium-drivers=$(driver_list "${GALLIUM_DRIVERS[*]}")
		-Dvulkan-drivers=$(driver_list "${VULKAN_DRIVERS[*]}")
		--buildtype $(usex debug debug release)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# Remove redundant GLES headers
	rm -f "${D}"/usr/include/{EGL,GLES2,GLES3,KHR}/*.h || die "Removing GLES headers failed."

	dodir /usr/$(get_libdir)/dri
	insinto "/usr/$(get_libdir)/dri/"
	insopts -m0755
	# install the gallium drivers we use
	local gallium_drivers_files=( nouveau_dri.so r300_dri.so r600_dri.so msm_dri.so swrast_dri.so )
	for x in ${gallium_drivers_files[@]}; do
		if [ -f "${S}/$(get_libdir)/gallium/${x}" ]; then
			doins "${S}/$(get_libdir)/gallium/${x}"
		fi
	done

	# install classic drivers we use
	local classic_drivers_files=( i810_dri.so i965_dri.so nouveau_vieux_dri.so radeon_dri.so r200_dri.so )
	for x in ${classic_drivers_files[@]}; do
		if [ -f "${S}/$(get_libdir)/${x}" ]; then
			doins "${S}/$(get_libdir)/${x}"
		fi
	done

	# Set driconf option to enable S3TC hardware decompression
	insinto "/etc/"
	doins "${FILESDIR}"/drirc
}

# $1 - VIDEO_CARDS flag (check skipped for "--")
# other args - names of DRI drivers to enable
dri_driver_enable() {
	if [[ $1 == -- ]] || use $1; then
		shift
		DRI_DRIVERS+=("$@")
	fi
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
