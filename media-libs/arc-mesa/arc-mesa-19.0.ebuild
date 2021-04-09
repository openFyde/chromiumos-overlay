# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mesa/mesa-7.9.ebuild,v 1.3 2010/12/05 17:19:14 arfrever Exp $

EAPI="6"

CROS_WORKON_COMMIT="2e7833ad916c493969d00871cdf56db4407b80eb"
CROS_WORKON_TREE="040a39591a38d3dc778725575c72dcdc1b07e032"
CROS_WORKON_PROJECT="chromiumos/third_party/mesa"
CROS_WORKON_LOCALNAME="arc-mesa"
CROS_WORKON_EGIT_BRANCH="master"
CROS_WORKON_MANUAL_UPREV="1"

EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/mesa"

MESON_AUTO_DEPEND=no

inherit base meson multilib-minimal flag-o-matic toolchain-funcs cros-workon arc-build

OPENGL_DIR="xorg-x11"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="http://mesa3d.sourceforge.net/"

# Most of the code is MIT/X11.
# ralloc is LGPL-3
# GLES[2]/gl[2]{,ext,platform}.h are SGI-B-2.0
LICENSE="MIT LGPL-3 SGI-B-2.0"
SLOT="0"
KEYWORDS="*"

INTEL_CARDS="intel"
RADEON_CARDS="amdgpu radeon"
VIDEO_CARDS="${INTEL_CARDS} ${RADEON_CARDS} llvmpipe mach64 mga nouveau powervr r128 savage sis vmware tdfx via freedreno virgl"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	android_aep -android_gles2 -android_gles30
	+android_gles31 -android_gles32 -android_vulkan_compute_0
	cheets +classic debug dri egl +gallium
	-gbm gles1 gles2 +llvm +nptl pic selinux shared-glapi vulkan X xlib-glx
	cheets_user cheets_user_64"

# llvmpipe requires ARC++ _userdebug images, ARC++ _user images can't use it
# (b/33072485, b/28802929).
# Only allow one vulkan driver as they all write vulkan.cheets.so.
REQUIRED_USE="
	^^ ( android_gles2 android_gles30 android_gles31 android_gles32 )
	android_aep? ( !android_gles2 !android_gles30 )
	android_vulkan_compute_0? ( vulkan )
	cheets? (
		vulkan? ( ^^ ( video_cards_amdgpu video_cards_intel ) )
		video_cards_amdgpu? ( llvm )
		video_cards_llvmpipe? ( !cheets_user !cheets_user_64 )
	)"

DEPEND="cheets? (
		>=x11-libs/arc-libdrm-2.4.82[${MULTILIB_USEDEP}]
		llvm? ( >=sys-devel/arc-llvm-9:=[${MULTILIB_USEDEP}] )
		video_cards_amdgpu? (
			dev-libs/arc-libelf[${MULTILIB_USEDEP}]
		)
	)"

RDEPEND="${DEPEND}"

# It is slow without texrels, if someone wants slow
# mesa without texrels +pic use is worth the shot
QA_EXECSTACK="usr/lib*/opengl/xorg-x11/lib/libGL.so*"
QA_WX_LOAD="usr/lib*/opengl/xorg-x11/lib/libGL.so*"

# Think about: ggi, fbcon, no-X configs

driver_list() {
	local drivers="$(sort -u <<< "${1// /$'\n'}")"
	echo "${drivers//$'\n'/,}"
}

pkg_setup() {
	# workaround toc-issue wrt #386545
	use ppc64 && append-flags -mminimal-toc

	# Remove symlinks created by an earlier version so we don't have
	# install conflicts.
	# TODO: Delete this after June 2019, since everybody should have
	# upgraded by then.
	local d
	for d in EGL GL GLES GLES2 GLES3 KHR; do
		local replaced_link="${ROOT}${ARC_CONTAINER_PREFIX}/vendor/include/${d}"
		if [[ -L "${replaced_link}" ]]; then
			rm -f "${replaced_link}"
		fi
	done
}

src_prepare() {
	# workaround for cros-workon not preserving git metadata
	if [[ ${PV} == 9999* && "${CROS_WORKON_INPLACE}" != "1" ]]; then
		echo "#define MESA_GIT_SHA1 \"git-deadbeef\"" > src/git_sha1.h
	fi

	# apply patches
	if [[ ${PV} != 9999* && -n ${SRC_PATCHES} ]]; then
		EPATCH_FORCE="yes" \
		EPATCH_SOURCE="${WORKDIR}/patches" \
		EPATCH_SUFFIX="patch" \
		epatch
	fi
	# FreeBSD 6.* doesn't have posix_memalign().
	if [[ ${CHOST} == *-freebsd6.* ]]; then
		sed -i \
			-e "s/-DHAVE_POSIX_MEMALIGN//" \
			configure.ac || die
	fi

	# Restrict gles version based on USE flag. (See crbug.com/30202361, b/30202371, b/31041422, b:68023287)
	if use android_gles32; then
		einfo "Limiting android to gles32."
		epatch "${FILESDIR}/gles32/0001-limit-gles-version.patch"
	elif use android_gles31; then
		einfo "Limiting android to gles31."
		epatch "${FILESDIR}/gles31/0001-limit-gles-version.patch"
	elif use android_gles30; then
		einfo "Limiting android to gles30."
		epatch "${FILESDIR}/gles30/0001-limit-gles-version.patch"
	elif use android_gles2; then
		einfo "Limiting android to gles2."
		epatch "${FILESDIR}/gles2/0001-limit-gles-version.patch"
	fi

	epatch "${FILESDIR}"/19.0-util-Don-t-block-SIGSYS-for-new-threads.patch
	epatch "${FILESDIR}"/19.0-radv-Use-given-stride-for-images-imported-from-Andro.patch

	epatch "${FILESDIR}"/CHROMIUM-intel-limit-urb-size-for-SKL-KBL-CFL-GT1.patch

	epatch "${FILESDIR}"/FROMLIST-configure.ac-meson.build-Add-optio.patch
	epatch "${FILESDIR}"/CHROMIUM-egl-android-plumb-swrast-option.patch
	epatch "${FILESDIR}"/CHROMIUM-egl-android-use-swrast-option-in-droid_load_driver.patch
	epatch "${FILESDIR}"/CHROMIUM-egl-android-fallback-to-software-rendering.patch
	epatch "${FILESDIR}"/UPSTREAM-egl-android-Remove-our-own-reference-to-buffers.patch

	epatch "${FILESDIR}"/CHROMIUM-anv-move-anv_GetMemoryAndroidHardwareBufferANDROID-u.patch
	epatch "${FILESDIR}"/CHROMIUM-remove-unknown-android-extensions.patch
	epatch "${FILESDIR}"/CHROMIUM-disable-unknown-device-extensions.patch

	epatch "${FILESDIR}"/CHROMIUM-HACK-radv-disable-TC-compatible-HTILE-on-Stoney.patch

	epatch "${FILESDIR}"/FROMLIST-egl-fix-KHR_partial_update-without-EXT_buff.patch
	epatch "${FILESDIR}"/BACKPORT-egl-android-Only-keep-BGRA-EGL-configs-as-fallback.patch
	epatch "${FILESDIR}"/FROMLIST-egl-android-require-ANDROID_native_fence_sy.patch
	epatch "${FILESDIR}"/FROMLIST-egl-android-Update-color_buffers-querying-for-buffer.patch

	epatch "${FILESDIR}"/FROMLIST-glsl-fix-an-incorrect-max_array_access-afte.patch
	epatch "${FILESDIR}"/FROMLIST-glsl-fix-a-binding-points-assignment-for-ss.patch
	epatch "${FILESDIR}"/UPSTREAM-glsl-mark-some-builtins-with-correct-glsl-es-version.patch

	epatch "${FILESDIR}"/FROMLIST-glcpp-Hack-to-handle-expressions-in-line-di.patch
	epatch "${FILESDIR}"/UPSTREAM-intel-Add-support-for-Comet-Lake.patch

	epatch "${FILESDIR}"/UPSTREAM-st-mesa-fix-2-crashes-in-st_tgsi_lower_yuv.patch

	epatch "${FILESDIR}"/CHROMIUM-Add-HAL_PIXEL_FORMAT_YCbCr_420_888-in-vk_format.patch
	epatch "${FILESDIR}"/CHROMIUM-Add-HAL_PIXEL_FORMAT_IMPLEMENTATION_DEFINED-in-vk_fo.patch

	epatch "${FILESDIR}"/CHROMIUM-radv-Disable-VK_KHR_create_renderpass2.patch

	epatch "${FILESDIR}"/FROMLIST-virgl-Set-meta-data-for-textures-from-handle.patch

	epatch "${FILESDIR}"/BACKPORT-egl-Enable-eglGetPlatformDisplay-on-Android.patch

	epatch "${FILESDIR}"/FROMLIST-anv-Fix-vulkan-build-in-meson.patch
	epatch "${FILESDIR}"/FROMLIST-anv-Add-android-dependencies-on-android.patch
	epatch "${FILESDIR}"/FROMLIST-radv-Fix-vulkan-build-in-meson.patch
	epatch "${FILESDIR}"/FROMLIST-meson-Allow-building-radeonsi-with-.patch
	epatch "${FILESDIR}"/FROMLIST-meson-i965-Link-with-android.patch
	epatch "${FILESDIR}"/FROMLIST-configure.ac-meson-depend-on-libnativewindow-when-ap.patch
	epatch "${FILESDIR}"/19.0-radeonsi-gfx9-honor-user-stride-for-imported-buffers.patch
	epatch "${FILESDIR}"/CHROMIUM-do-not-initialize-destroy-locale-for-strtod.patch

	epatch "${FILESDIR}"/UPSTREAM-drm-uapi-Update-headers-for-fp16-formats.patch
	epatch "${FILESDIR}"/BACKPORT-i965-Add-helper-function-for-allowed-config.patch
	epatch "${FILESDIR}"/UPSTREAM-dri-Add-config-attributes-for-color-channel.patch
	epatch "${FILESDIR}"/UPSTREAM-util-move-bitcount-to-bitscan.h.patch
	epatch "${FILESDIR}"/BACKPORT-egl-Convert-configs-to-use-shifts-and-sizes.patch
	epatch "${FILESDIR}"/UPSTREAM-glx-Add-fields-for-color-shifts.patch
	epatch "${FILESDIR}"/BACKPORT-dri-Handle-configs-with-floating-point-pixe.patch
	epatch "${FILESDIR}"/UPSTREAM-egl-Handle-dri-configs-with-floating-point-.patch
	epatch "${FILESDIR}"/BACKPORT-dri-Add-fp16-formats.patch
	epatch "${FILESDIR}"/UPSTREAM-gbm-Add-buffer-handling-and-visuals-for-fp1.patch
	epatch "${FILESDIR}"/BACKPORT-i965-Add-handling-for-fp16-configs.patch
	epatch "${FILESDIR}"/UPSTREAM-egl-android-Enable-HAL_PIXEL_FORMAT_RGBA_FP.patch
	epatch "${FILESDIR}"/BACKPORT-egl-android-Enable-HAL_PIXEL_FORMAT_RGBA_10.patch
	epatch "${FILESDIR}"/UPSTREAM-intel-compiler-force-simd8-when-dual-src-blending-on.patch

	epatch "${FILESDIR}"/UPSTREAM-i965-setup-sized-internalformat-for-MESA_FO.patch

	epatch "${FILESDIR}"/UPSTREAM-anv-expose-VK_EXT_queue_family_foreign-on-A.patch
	epatch "${FILESDIR}"/UPSTREAM-intel-limit-shader-geometry-on-BDW-GT1.patch
	epatch "${FILESDIR}"/UPSTREAM-intel-change-urb-max-shader-geometry-for-KBL-GT1.patch
	epatch "${FILESDIR}"/UPSTREAM-intel-change-urb-max-shader-geometry-for-CML-GT1.patch
	default
}

src_configure() {
	cros_optimize_package_for_speed
	# Need to filter out --icf=all in this package temporarily because of failure in Gold linker
	# https://crbug.com/1022226
	filter-ldflags "-Wl,--icf=all"
	if use cheets; then
		#
		# cheets-specific overrides
		#

		arc-build-select-clang
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	tc-getPROG PKG_CONFIG pkg-config

	if use !gallium && use !classic; then
		ewarn "You enabled neither classic nor gallium USE flags. No hardware"
		ewarn "drivers will be built."
	fi

	if use classic; then
	# Configurable DRI drivers
		# Intel code
		driver_enable video_cards_intel i965

		# Nouveau code
		driver_enable video_cards_nouveau nouveau

		# ATI code
		driver_enable video_cards_radeon r100 r200
	fi

	if use gallium; then
	# Configurable gallium drivers
		gallium_enable video_cards_llvmpipe swrast

		# Nouveau code
		gallium_enable video_cards_nouveau nouveau

		# ATI code
		gallium_enable video_cards_radeon r300 r600
		gallium_enable video_cards_amdgpu radeonsi

		# Freedreno code
		gallium_enable video_cards_freedreno freedreno

		gallium_enable video_cards_virgl virgl
	fi

	if use vulkan; then
		vulkan_enable video_cards_amdgpu amd
		vulkan_enable video_cards_intel intel
	fi

	export LLVM_CONFIG=${SYSROOT}/usr/bin/llvm-config-host
	EGL_PLATFORM="surfaceless"

	if use cheets; then
		#
		# cheets-specific overrides
		#

		MESA_PLATFORM_SDK_VERSION=${ARC_PLATFORM_SDK_VERSION}

		# Use llvm-config coming from ARC++ build.
		export LLVM_CONFIG="${ARC_SYSROOT}/build/bin/llvm-config-host"

		# FIXME(tfiga): Possibly use flag?
		EGL_PLATFORM="android"

		# The AOSP build system defines the Make variable
		# PLATFORM_SDK_VERSION, and Mesa's Android.mk files use it to
		# define the macro ANDROID_API_LEVEL. Arc emulates that here.
		if [[ -n "${ARC_PLATFORM_SDK_VERSION}" ]]; then
			CPPFLAGS+=" -DANDROID_API_LEVEL=${ARC_PLATFORM_SDK_VERSION}"
		fi

		#
		# end of arc-mesa specific overrides
		#
	fi

	if ! use llvm; then
		export LLVM_CONFIG="no"
	fi

	arc-build-create-cross-file

	emesonargs+=(
		$(use cheets && echo "--prefix=${ARC_CONTAINER_PREFIX}/vendor")
		$(use cheets && echo "--sysconfdir=/system/vendor/etc")
		$(use cheets && echo "-Ddri-search-path=/system/$(get_libdir)/dri:/system/vendor/$(get_libdir)/dri")
		-Dgallium-va=false
		-Dgallium-vdpau=false
		-Dgallium-xvmc=false
		-Dgallium-omx=disabled
		-Dgallum-xa=false
		-Dasm=false
		-Dglx=disabled
		-Ddri3=false
		-Dgles-lib-suffix=_mesa
		-Degl-lib-suffix=_mesa
		$(meson_use llvm)
		$(use egl && echo "-Dplatforms=${EGL_PLATFORM}")
		$(meson_use egl)
		$(meson_use gbm)
		$(meson_use gles1)
		$(meson_use gles2)
		$(meson_use selinux)
		$(meson_use shared-glapi)
		-Ddri-drivers=$(driver_list "${DRI_DRIVERS[*]}")
		-Dgallium-drivers=$(driver_list "${GALLIUM_DRIVERS[*]}")
		-Dvulkan-drivers=$(driver_list "${VULKAN_DRIVERS[*]}")
		--buildtype $(usex debug debug release)
		$(use cheets && echo "--cross-file=${ARC_CROSS_FILE}")
		$(use cheets && echo "-Dplatform-sdk-version=${ARC_PLATFORM_SDK_VERSION}")
	)

	meson_src_configure
}

# The meson eclass exports src_compile but not multilib_src_compile. src_compile
# gets overridden by multilib-minimal
multilib_src_compile() {
	meson_src_compile
}

multilib_src_install_cheets() {
	exeinto "${ARC_CONTAINER_PREFIX}/vendor/$(get_libdir)"
	newexe ${BUILD_DIR}/src/mapi/shared-glapi/libglapi.so.0 libglapi.so.0

	exeinto "${ARC_CONTAINER_PREFIX}/vendor/$(get_libdir)/egl"
	newexe ${BUILD_DIR}/src/egl/libEGL_mesa.so libEGL_mesa.so
	newexe ${BUILD_DIR}/src/mapi/es1api/libGLESv1_CM_mesa.so libGLESv1_CM_mesa.so
	newexe ${BUILD_DIR}/src/mapi/es2api/libGLESv2_mesa.so libGLESv2_mesa.so

	exeinto "${ARC_CONTAINER_PREFIX}/vendor/$(get_libdir)/dri"
	if use classic && use video_cards_intel; then
		newexe ${BUILD_DIR}/src/mesa/drivers/dri/libmesa_dri_drivers.so i965_dri.so
	fi
	if use gallium; then
		if use video_cards_llvmpipe; then
			newexe ${BUILD_DIR}/src/gallium/targets/dri/libgallium_dri.so kms_swrast_dri.so
		fi
		if use video_cards_amdgpu; then
			newexe ${BUILD_DIR}/src/gallium/targets/dri/libgallium_dri.so radeonsi_dri.so
		fi
		if use video_cards_virgl; then
			newexe ${BUILD_DIR}/src/gallium/targets/dri/libgallium_dri.so virtio_gpu_dri.so
		fi
	fi

	if use vulkan; then
		exeinto "${ARC_CONTAINER_PREFIX}/vendor/$(get_libdir)/hw"
		if use video_cards_amdgpu; then
			newexe ${BUILD_DIR}/src/amd/vulkan/libvulkan_radeon.so vulkan.cheets.so
		fi
		if use video_cards_intel; then
			newexe ${BUILD_DIR}/src/intel/vulkan/libvulkan_intel.so vulkan.cheets.so
		fi
	fi
}

multilib_src_install() {
	if use cheets; then
		multilib_src_install_cheets
		return
	fi

	meson_src_install

	# Remove redundant headers
	# GLU and GLUT
	rm -f "${D}"/usr/include/GL/glu*.h || die "Removing GLU and GLUT headers failed."
	# Glew includes
	rm -f "${D}"/usr/include/GL/{glew,glxew,wglew}.h \
		|| die "Removing glew includes failed."

	# Move libGL and others from /usr/lib to /usr/lib/opengl/blah/lib
	# because user can eselect desired GL provider.
	ebegin "Moving libGL and friends for dynamic switching"
		dodir /usr/$(get_libdir)/opengl/${OPENGL_DIR}/{lib,extensions,include}
		local x
		for x in "${D}"/usr/$(get_libdir)/libGL.{la,a,so*}; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f "${x}" "${D}"/usr/$(get_libdir)/opengl/${OPENGL_DIR}/lib \
					|| die "Failed to move ${x}"
			fi
		done
		for x in "${D}"/usr/include/GL/{gl.h,glx.h,glext.h,glxext.h}; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f "${x}" "${D}"/usr/$(get_libdir)/opengl/${OPENGL_DIR}/include \
					|| die "Failed to move ${x}"
			fi
		done
	eend $?

	dodir /usr/$(get_libdir)/dri
	insinto "/usr/$(get_libdir)/dri/"
	insopts -m0755
	# install the gallium drivers we use
	local gallium_drivers_files=( i915_dri.so nouveau_dri.so r300_dri.so r600_dri.so msm_dri.so swrast_dri.so )
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
}

multilib_src_install_all_cheets() {
	# Set driconf option to enable S3TC hardware decompression
	insinto "${ARC_CONTAINER_PREFIX}/vendor/etc/"
	doins "${FILESDIR}"/drirc

	# For documentation on the feature set represented by each XML file
	# installed into /vendor/etc/permissions, see
	# <https://developer.android.com/reference/android/content/pm/PackageManager.html>.
	# For example XML files for each feature, see
	# <https://android.googlesource.com/platform/frameworks/native/+/master/data/etc>.

	# Install init files to advertise supported API versions.
	insinto "${ARC_CONTAINER_PREFIX}/vendor/etc/init"
	if use android_gles32; then
		doins "${FILESDIR}/gles32/init.gpu.rc"
	elif use android_gles31; then
		doins "${FILESDIR}/gles31/init.gpu.rc"
	elif use android_gles30; then
		doins "${FILESDIR}/gles30/init.gpu.rc"
	elif use android_gles2; then
		doins "${FILESDIR}/gles2/init.gpu.rc"
	fi

	# Install vulkan related files.
	if use vulkan; then
		einfo "Using android vulkan."
		insinto "${ARC_CONTAINER_PREFIX}/vendor/etc/init"
		doins "${FILESDIR}/vulkan.rc"

		insinto "${ARC_CONTAINER_PREFIX}/vendor/etc/permissions"

		if use video_cards_intel; then
			doins "${FILESDIR}/android.hardware.vulkan.level-1.xml"
		else
			doins "${FILESDIR}/android.hardware.vulkan.level-0.xml"
		fi

		doins "${FILESDIR}/android.hardware.vulkan.version-1_1.xml"
	fi

	if use android_vulkan_compute_0; then
		einfo "Using android vulkan_compute_0."
		insinto "${ARC_CONTAINER_PREFIX}/vendor/etc/permissions"
		doins "${FILESDIR}/android.hardware.vulkan.compute-0.xml"
	fi

	# Install permission file to declare opengles aep support.
	if use android_aep; then
		einfo "Using android aep."
		insinto "${ARC_CONTAINER_PREFIX}/vendor/etc/permissions"
		doins "${FILESDIR}/android.hardware.opengles.aep.xml"
	fi

	# Install the dri header for arc-cros-gralloc
	insinto "${ARC_CONTAINER_PREFIX}/vendor/include/GL"
	doins -r "${S}/include/GL/internal"
}

multilib_src_install_all() {
	if use cheets; then
		multilib_src_install_all_cheets
		return
	fi

	# Set driconf option to enable S3TC hardware decompression
	insinto "/etc/"
	doins "${FILESDIR}"/drirc
}

pkg_postinst() {
	if use cheets; then
		return
	fi

	# Switch to the xorg implementation.
	echo
	eselect opengl set --use-old ${OPENGL_DIR}
}

# $1 - VIDEO_CARDS flag
# other args - names of DRI drivers to enable
driver_enable() {
	case $# in
		# for enabling unconditionally
		1)
			DRI_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					DRI_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}

gallium_enable() {
	case $# in
		# for enabling unconditionally
		1)
			GALLIUM_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					GALLIUM_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}

vulkan_enable() {
	case $# in
		# for enabling unconditionally
		1)
			VULKAN_DRIVERS+=",$1"
			;;
		*)
			if use $1; then
				shift
				for i in $@; do
					VULKAN_DRIVERS+=",${i}"
				done
			fi
			;;
	esac
}
