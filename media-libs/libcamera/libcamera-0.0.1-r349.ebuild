# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="afbf0ec626db43b0117d28ef4f9b825a7d19929a"
CROS_WORKON_TREE="c5ddfb6da7069e50a66f36313f2f4a75e4e94a9a"
CROS_WORKON_PROJECT="chromiumos/third_party/libcamera"
CROS_WORKON_INCREMENTAL_BUILD="1"

inherit cros-workon meson

DESCRIPTION="Camera support library for Linux"
HOMEPAGE="https://www.libcamera.org"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="doc ipu3 rkisp1 test udev"

RDEPEND="
	media-libs/libjpeg-turbo
	media-libs/libexif
	>=net-libs/gnutls-3.3:=
	udev? ( virtual/libudev )
"

DEPEND="
	${RDEPEND}
	dev-libs/openssl
	>=dev-python/pyyaml-3:=
"

src_configure() {
	local pipelines=(
		"uvcvideo"
		$(usev ipu3)
		$(usev rkisp1)
	)

	pipeline_list() {
		printf '%s,' "$@" | sed 's:,$::'
	}

	BUILD_DIR="$(cros-workon_get_build_dir)"

	local emesonargs=(
		$(meson_use test)
		$(meson_feature doc documentation)
		-Dandroid="enabled"
		-Dpipelines="$(pipeline_list "${pipelines[@]}")"
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install

	dosym ../libcamera.so "/usr/$(get_libdir)/camera_hal/libcamera.so"
}
