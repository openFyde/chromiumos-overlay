# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="b0854045cbbf0862e60f56e259fb36ff130d8e97"
CROS_WORKON_TREE="0cd1e90f14ef633f79ac743f4ab0b82de2e8a887"
CROS_WORKON_PROJECT="chromiumos/platform/gestures"
CROS_WORKON_USE_VCSID=1

inherit toolchain-funcs multilib cros-debug cros-sanitizers cros-workon

DESCRIPTION="Gesture recognizer library"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan +X"

RDEPEND="chromeos-base/gestures-conf
	chromeos-base/libevdev
	dev-libs/jsoncpp
	virtual/udev"
DEPEND="dev-cpp/gtest:=
	X? ( x11-libs/libXi )
	${RDEPEND}"

# The last dir must be named "gestures" for include path reasons.
S="${WORKDIR}/gestures"

src_configure() {
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
