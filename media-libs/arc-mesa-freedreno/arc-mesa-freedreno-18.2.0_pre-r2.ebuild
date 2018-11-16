# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

CROS_WORKON_COMMIT="bdc17eef1acc02d2f99f17f259abec8983c64c36"
CROS_WORKON_TREE="f0429e55193992df5a5db422bc4a694c87f4e489"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="arc-mesa"

inherit base autotools flag-o-matic toolchain-funcs cros-workon arc-build

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="http://mesa3d.sourceforge.net/"

KEYWORDS="*"

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

	base_src_prepare
	eautoreconf
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

	econf \
		--prefix="${ARC_PREFIX}/vendor" \
		--sysconfdir=/system/vendor/etc \
		\
		$(use_enable debug) \
		--enable-sysfs \
		--enable-cross_compiling \
		--disable-option-checking \
		--enable-texture-float \
		--disable-dri3 \
		--disable-glx \
		--disable-gbm \
		--enable-gles1 \
		--enable-gles2 \
		--enable-shared-glapi \
		--with-vulkan-drivers= \
		--with-egl-platforms=android \
		--with-dri-searchpath="/system/$(get_libdir)/dri:/system/vendor/$(get_libdir)/dri" \
		--with-dri-drivers= \
		--with-gallium-drivers=freedreno \
		--with-egl-lib-suffix=_mesa \
		--with-gles-lib-suffix=_mesa
}

src_install() {
	exeinto "${ARC_PREFIX}/vendor/$(get_libdir)"
	newexe $(get_libdir)/libglapi.so libglapi.so

	exeinto "${ARC_PREFIX}/vendor/$(get_libdir)/egl"
	newexe $(get_libdir)/libEGL.so libEGL_mesa.so
	newexe $(get_libdir)/libGLESv1_CM.so libGLESv1_CM_mesa.so
	newexe $(get_libdir)/libGLESv2.so libGLESv2_mesa.so

	exeinto "${ARC_PREFIX}/vendor/$(get_libdir)/dri"
	newexe $(get_libdir)/gallium/msm_dri.so msm_dri.so

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
	doins -r "${S}/include/GL/internal"
}
