# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c8c1d07cea2d8ef63905bf4f0b5266a5e6fd749f"
CROS_WORKON_TREE="bca4499b7e8a5deeaeb6315f52bb9adb9f5b46e6"
CROS_WORKON_PROJECT="chromiumos/third_party/libcamera"
CROS_WORKON_INCREMENTAL_BUILD="1"

inherit cros-camera cros-workon meson

DESCRIPTION="Camera support library for Linux"
HOMEPAGE="https://www.libcamera.org"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="debug dev doc ipu3 rkisp1 test udev"

RDEPEND="
	chromeos-base/cros-camera-libs
	dev? ( dev-libs/libevent[threads] )
	dev-libs/libyaml
	media-libs/libcamera-configs
	media-libs/libjpeg-turbo
	media-libs/libexif
	>=net-libs/gnutls-3.3:=
	media-libs/libyuv
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
		$(meson_feature dev cam)
		$(meson_feature doc documentation)
		-Dandroid="enabled"
		-Dandroid_platform="cros"
		-Dpipelines="$(pipeline_list "${pipelines[@]}")"
		--buildtype "$(usex debug debug plain)"
		--sysconfdir /etc/camera
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install

	cros-camera_dohal "${D}/usr/$(get_libdir)/libcamera-hal.so" libcamera-hal.so

	dostrip -x "/usr/$(get_libdir)/libcamera/"
}
