# Copyright 2019 The Chromium OS Authros. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b80527734ad996fdf369af9fc3b171fe997f3858"
CROS_WORKON_TREE="8b161c6f7b90a49e76c005b5e32f25a84345576c"
CROS_WORKON_PROJECT="chromiumos/platform/glbench"
CROS_WORKON_LOCALNAME="platform/glbench"

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
	insinto "${glbench_dir}/bin"
	doins -r runtime

	# Install the list files.
	insinto "${glbench_dir}/files"
	doins glbench_fixedbad_images.txt
	doins glbench_knownbad_images.txt
	doins glbench_reference_images.txt
}
