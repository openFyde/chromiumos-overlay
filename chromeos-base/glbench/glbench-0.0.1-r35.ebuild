# Copyright 2019 The Chromium OS Authros.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2ddbf4ab665b9e7de6ec333266151b836a0e441d"
CROS_WORKON_TREE="114bf3963c01728ed455fbbbe443bfb06385a494"
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
