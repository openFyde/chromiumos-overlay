# Copyright 2019 The Chromium OS Authros.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f1aac9ca04e4516d7e7eb79ddb3859842b98d3e6"
CROS_WORKON_TREE="c59d213542a8eb5359bec16f5a7c0e8f4738a33b"
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
	media-libs/libepoxy:=
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
	doexe glbench compositortest windowmanagertest
	insinto "${glbench_dir}/bin"
	doins -r runtime

	# Install the list files.
	insinto "${glbench_dir}/files"
	doins glbench_fixedbad_images.txt
	doins glbench_knownbad_images.txt
	doins glbench_reference_images.txt
}
