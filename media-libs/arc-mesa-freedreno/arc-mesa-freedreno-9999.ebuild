# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="mesa-freedreno"

inherit base meson flag-o-matic toolchain-funcs cros-workon arc-build

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="http://mesa3d.sourceforge.net/"

KEYWORDS="~*"

# Most files are MIT/X11.
# Some files in src/glx are SGI-B-2.0.
LICENSE="MIT SGI-B-2.0"
SLOT="0"

IUSE="
	cheets
	cheets_user
	cheets_user_64
	debug
	video_cards_freedreno
	-vulkan
"

REQUIRED_USE="
	cheets
"

DEPEND="
	>=sys-devel/arc-build-0.0.2
	>=x11-libs/arc-libdrm-2.4.82[video_cards_freedreno,${MULTILIB_USEDEP}]
	video_cards_freedreno? (
		dev-libs/arc-libelf[${MULTILIB_USEDEP}]
	)
"

RDEPEND="${DEPEND}"

pkg_pretend() {
	if use vulkan; then
		die "${PN} does not yet support vulkan"
	fi
}

src_prepare() {
	# workaround for cros-workon not preserving git metadata
	if [[ ${PV} == 9999* && "${CROS_WORKON_INPLACE}" != "1" ]]; then
		echo "#define MESA_GIT_SHA1 \"git-deadbeef\"" > src/git_sha1.h
	fi

	default
}

src_configure() {
	arc-build-select-clang

	# The AOSP build system defines the Make variable PLATFORM_SDK_VERSION,
	# and Mesa's Android.mk files use it to define the macro
	# ANDROID_API_LEVEL. Arc emulates that here.
	if [[ -n "${ARC_PLATFORM_SDK_VERSION}" ]]; then
		CPPFLAGS+=" -DANDROID_API_LEVEL=${ARC_PLATFORM_SDK_VERSION}"
	fi

	tc-getPROG PKG_CONFIG pkg-config

	# Need std=gnu++11 to build with libc++. crbug.com/750831
	append-cxxflags "-std=gnu++11"
	append-cppflags "-UENABLE_SHADER_CACHE"

	if use debug; then
		emesonargs+=( -Dbuildtype=debug)
	fi

	emesonargs+=(
		--prefix="${ARC_PREFIX}/vendor"
		--sysconfdir="/system/vendor/etc"
		-Ddri-search-path="/system/$(get_libdir)/dri:/system/vendor/$(get_libdir)/dri"
		-Dllvm=false
		-Ddri3=false
		-Dglx=disabled
		-Degl=true
		-Dgbm=false
		-Dgles1=true
		-Dgles2=true
		-Dshared-glapi=true
		-Ddri-drivers=
		-Dgallium-drivers=freedreno
		-Dgallium-vdpau=false
		-Dgallium-xa=false
		-Dplatforms=android
		-Degl-lib-suffix=_mesa
		-Dgles-lib-suffix=_mesa
	)

	if use vulkan; then
		emesonargs+=( -Dvulkan-drivers=freedreno )
	else
		emesonargs+=( -Dvulkan-drivers= )
	fi

	meson_src_configure
}

src_install() {
	build_dir="${WORKDIR}/arc-mesa-freedreno-${PV}-build"
	install_dir="${WORKDIR}/arc-mesa-freedreno-${PV}-install"
	DESTDIR=${install_dir} ninja -C ${build_dir} install
	vendor_dir="${install_dir}/opt/google/containers/android/vendor"

	exeinto "${ARC_PREFIX}/vendor/$(get_libdir)"
	newexe ${vendor_dir}/lib/libglapi.so.0.0.0 libglapi.so.0.0.0
	dosym libglapi.so.0.0.0 "${ARC_PREFIX}/vendor/$(get_libdir)"/libglapi.so.0 
	dosym libglapi.so.0 "${ARC_PREFIX}/vendor/$(get_libdir)"/libglapi.so

	exeinto "${ARC_PREFIX}/vendor/$(get_libdir)/egl"
	newexe ${vendor_dir}/lib/libEGL_mesa.so libEGL_mesa.so
	newexe ${vendor_dir}/lib/libGLESv1_CM_mesa.so libGLESv1_CM_mesa.so
	newexe ${vendor_dir}/lib/libGLESv2_mesa.so libGLESv2_mesa.so

	exeinto "${ARC_PREFIX}/vendor/$(get_libdir)/dri"
	newexe ${vendor_dir}/lib/dri/msm_dri.so msm_dri.so

	# For documentation on the feature set represented by each XML file
	# installed into /vendor/etc/permissions, see
	# <https://developer.android.com/reference/android/content/pm/PackageManager.html>.
	# For example XML files for each feature, see
	# <https://android.googlesource.com/platform/frameworks/native/+/master/data/etc>.

	# Install init files to advertise supported API versions.
	insinto "${ARC_PREFIX}/vendor/etc/init"
	doins "${FILESDIR}/gles30.rc"

	# Install the dri header for arc-cros-gralloc
	insinto "${ARC_PREFIX}/vendor/include/GL"
	doins -r "${vendor_dir}/include/GL/internal"
}
