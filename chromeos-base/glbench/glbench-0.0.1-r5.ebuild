# Copyright 2019 The Chromium OS Authros. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="b0595eb94d8c1950f0e8509a06921a035caba464"
CROS_WORKON_TREE="f083a0168e32d090c52da9525d1b098fc16871f6"
CROS_WORKON_PROJECT="chromiumos/platform/glbench"

inherit cros-workon

DESCRIPTION="Microbenchmark for opengl/gles"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/glbench/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="opengl opengles"

RDEPEND="
	>=dev-cpp/gflags-2.0
	media-libs/libpng
	virtual/opengles
	media-libs/waffle"
DEPEND="${RDEPEND}
	x11-drivers/opengles-headers"

src_compile() {
	emake -C src
}

src_install() {
	local glbench_dir="/usr/local/${PN}"

	# Install the executable.
	exeinto "${glbench_dir}/bin"
	doexe glbench windowmanagertest

	# Install the list files.
	insinto "${glbench_dir}/files"
	doins glbench_fixedbad_images.txt
	doins glbench_knownbad_images.txt
	doins glbench_reference_images.txt
}
