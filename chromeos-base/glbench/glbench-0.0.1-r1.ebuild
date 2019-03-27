# Copyright 2019 The Chromium OS Authros. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="c12ead270fdfadd43461f1cecdde3dc6a5b0b2d7"
CROS_WORKON_TREE="47b3fe6469fc5ef0d82a37d8f6d5d442d9f921f3"
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
