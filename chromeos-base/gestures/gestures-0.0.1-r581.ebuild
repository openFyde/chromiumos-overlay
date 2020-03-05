# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2046c5600e64d87db06dcb8d18236d7d199fbc8a"
CROS_WORKON_TREE="755364ed11c59682c7ff7715479035b23130c722"
CROS_WORKON_PROJECT="chromiumos/platform/gestures"
CROS_WORKON_LOCALNAME="platform/gestures"
CROS_WORKON_USE_VCSID=1

inherit toolchain-funcs multilib cros-debug cros-sanitizers cros-workon

DESCRIPTION="Gesture recognizer library"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-asan +X"

RDEPEND="chromeos-base/gestures-conf:=
	chromeos-base/libevdev:=
	dev-libs/jsoncpp:=
	virtual/udev"
DEPEND="dev-cpp/gtest:=
	X? ( x11-libs/libXi:= )
	${RDEPEND}"

# The last dir must be named "gestures" for include path reasons.
S="${WORKDIR}/gestures"

src_configure() {
	cros_optimize_package_for_speed
	sanitizers-setup-env
	cros-workon_src_configure
	export USE_X11=$(usex X 1 0)
}

src_compile() {
	tc-export CXX
	cros-debug-add-NDEBUG

	emake clean  # TODO(adlr): remove when a better solution exists
	emake
}

src_test() {
	emake test

	if ! use x86 && ! use amd64 ; then
		einfo "Skipping tests on non-x86 platform..."
	else
		# This is an ugly hack that happens to work, but should not be copied.
		LD_LIBRARY_PATH="${SYSROOT}/usr/$(get_libdir)" \
		./test || die
	fi
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" install
}
