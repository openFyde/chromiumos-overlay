# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: arc-build.eclass
# @MAINTAINER:
# Chromium OS Build Team
# @BUGREPORTS:
# Please report bugs via http://crbug.com/new (with label Build)
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/master/eclass/@ECLASS@
# @BLURB: helper eclass for building packages to run under ARC (Android Runtime)
# @DESCRIPTION:
# We want to build some libraries to run under ARC.  These funcs will help
# write ebuilds to accomplish that.

# @ECLASS-VARIABLE: ARC_BASE
# @DESCRIPTION:
# The path to ARC toolchain root directory. Normally defined by the profile.
# e.g. /opt/android-n, for sys-devel/arc-toolchain-n

# @ECLASS-VARIABLE: ARC_VERSION_MAJOR
# @DESCRIPTION:
# Major version of Android that was used to generate the ARC toolchain.
# Normally defined by the profile. e.g. 7, for Android 7.1.0

# @ECLASS-VARIABLE: ARC_VERSION_MINOR
# @DESCRIPTION:
# Minor version of Android that was used to generate the ARC toolchain.
# Normally defined by the profile. e.g. 1, for Android 7.1.0

# @ECLASS-VARIABLE: ARC_VERSION_PATCH
# @DESCRIPTION:
# Minor version of Android that was used to generate the ARC toolchain.
# Normally defined by the profile. e.g. 0, for Android 7.1.0

# @ECLASS-VARIABLE: ARC_LLVM_VERSION
# @DESCRIPTION:
# Version of LLVM included in the ARC toolchain.
# Normally defined by the profile, e.g. 3.8, for arc-toolchain-n

if [[ -z ${_ARC_BUILD_ECLASS} ]]; then
_ARC_BUILD_ECLASS=1

# Check for EAPI 4+.
case "${EAPI:-0}" in
4|5|6) ;;
*) die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
esac

inherit multilib-build flag-o-matic cros-constants

DEPEND="sys-devel/arc-build[${MULTILIB_USEDEP}]"

# Make sure we know how to handle the active system.
arc-build-check-arch() {
	case ${ARCH} in
	arm|amd64) ;;
	*) die "Unsupported arch ${ARCH}" ;;
	esac
}

_arc-build-select-common() {
	if [[ -n ${ARC_SYSROOT} ]] ; then
		# If we've already been set up, don't re-run.
		return 0
	fi

	arc-build-check-arch

	export ARC_SYSROOT="${SYSROOT}${ARC_PREFIX}"
	export PKG_CONFIG="${ARC_SYSROOT}/build/bin/pkg-config"

	case ${ARCH} in
	arm)
		ARC_GCC_TUPLE=arm-linux-androideabi
		ARC_GCC_BASE="${ARC_BASE}/arc-gcc/arm/${ARC_GCC_TUPLE}-4.9"
		ARC_GCC_LIBDIR="${ARC_BASE}/lib/gcc/${ARC_GCC_TUPLE}/4.9"

		export CHOST="${ARC_GCC_TUPLE}"
		append-cppflags -I"${ARC_SYSROOT}/usr/include/arch-arm/include/"
		;;
	amd64)
		ARC_GCC_TUPLE=x86_64-linux-android
		ARC_GCC_BASE="${ARC_BASE}/arc-gcc/x86_64/${ARC_GCC_TUPLE}-4.9"
		ARC_GCC_LIBDIR="${ARC_BASE}/lib/gcc/${ARC_GCC_TUPLE}/4.9"

		# multilib.eclass does not use CFLAGS_${DEFAULT_ABI}, but
		# we need to add some flags valid only for amd64, so we trick
		# it to think that neither x86 nor amd64 is the default.
		export DEFAULT_ABI=none
		export CHOST=x86_64-linux-android
		export CHOST_amd64=x86_64-linux-android
		export CHOST_x86=i686-linux-android
		export CFLAGS_amd64="${CFLAGS_amd64} -I${ARC_SYSROOT}/usr/include/arch-x86_64/include/"
		export CFLAGS_x86="${CFLAGS_x86} -I${ARC_SYSROOT}/usr/include/arch-x86/include/"
		;;
	esac

	# Add Android related utilities location to ${PATH}.
	export PATH="${ARC_GCC_BASE}/bin:${PATH}"

	# Strip out flags that are specific to our compiler wrapper.
	filter-flags -clang-syntax

	# Android uses soft floating point still.
	filter-flags -mfpu=neon -mfloat-abi=hard

	# Set up flags for the android sysroot.
	append-flags --sysroot="${ARC_SYSROOT}"
	local android_version=$(printf "0x%04x" \
		$(((ARC_VERSION_MAJOR << 8) + ARC_VERSION_MINOR)))
	append-cppflags -DANDROID -DANDROID_VERSION=${android_version}
	append-cxxflags -I${ARC_SYSROOT}/usr/include/c++/4.9 -lc++
}

# Set up the compiler settings for GCC.
arc-build-select-gcc() {
	_arc-build-select-common

	export CC="${ARC_GCC_BASE}/bin/${ARC_GCC_TUPLE}-gcc"
	export CXX="${ARC_GCC_BASE}/bin/${ARC_GCC_TUPLE}-g++"
	export CCLD="${CC}"
}

arc-build-select-clang() {
	_arc-build-select-common

	append-flags "--gcc-toolchain=${ARC_GCC_BASE}"
	append-flags -target "${CHOST}"

	ARC_LLVM_BASE="${ARC_BASE}/arc-llvm/${ARC_LLVM_VERSION}"
	export CC="${ARC_LLVM_BASE}/bin/clang"
	export CXX="${ARC_LLVM_BASE}/bin/clang++"
	# Needed to make libtool pass arc-toolchain-n clang flags
	# through to linker command lines.
	export CCLD="\${CC} -XCClinker --gcc-toolchain=${ARC_GCC_BASE} -XCClinker -target -XCClinker \${CHOST}"
}

fi
