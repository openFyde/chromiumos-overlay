# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="42e537f3c57623cab53e848b6d663df040f26d20"
CROS_WORKON_TREE="da0169eba8f145091b75ad6486807c4e390bb892"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly

DESCRIPTION="dependencies for Piglit (collection of automated tests for OpenGl based on glean and mesa)"
HOMEPAGE="http://cgit.freedesktop.org/piglit"
SRC_URI=""
LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest opengl"

AUTOTEST_DEPS_LIST="piglit"
RDEPEND="
	opengl? ( virtual/glut )
	opengl? ( virtual/opengl )
	dev-python/mako
	dev-python/numpy
	media-libs/tiff
	media-libs/libpng
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXpm
	x11-libs/libXrender
	opengl? ( x11-proto/glproto )
	"
# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

DEPEND="${RDEPEND}"

src_configure() {
	# export a variable so that piglit knows where to find libglut.so
	export GLUT_LIBDIR="/usr/$(get_libdir)"

	default
}
