# Copyright 2019 The Chromium OS Authros. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="217dd1abc66f11db0862b6dcbc90b4a59ef25c07"
CROS_WORKON_TREE="5e634be7a9dd8e992b1c99591ddc8677750958b8"
CROS_WORKON_PROJECT="chromiumos/platform/glbench"

inherit cros-workon

DESCRIPTION="Microbenchmark for opengl/gles"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/glbench/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="opengl opengles"

COMMON_DEPEND="
	>=dev-cpp/gflags-2.0:=
	media-libs/libpng:=
	virtual/opengles:=
	media-libs/waffle:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	x11-drivers/opengles-headers:="

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
