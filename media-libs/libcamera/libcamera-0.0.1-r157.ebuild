# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="8823461d80ad64b972bc6d568c47aba50bed26a4"
CROS_WORKON_TREE="fe962d4ff9e796ec578edcaf45ccabf25540fac8"
CROS_WORKON_PROJECT="chromiumos/third_party/libcamera"
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-workon meson

DESCRIPTION="Camera support library for Linux"
HOMEPAGE="https://www.libcamera.org"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="arc-camera3 doc ipu3 rkisp1 test udev"

RDEPEND="udev? ( virtual/libudev )"
DEPEND="${RDEPEND}"

src_configure() {
	local pipelines=(
		"uvcvideo"
		$(usev ipu3)
		$(usev rkisp1)
	)

	pipeline_list() {
		printf '%s,' "$@" | sed 's:,$::'
	}

	local emesonargs=(
		$(meson_use arc-camera3 android)
		$(meson_use doc documentation)
		$(meson_use test)
		-Dpipelines="$(pipeline_list "${pipelines[@]}")"
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install

	if use arc-camera3 ; then
		dosym ../libcamera.so "/usr/$(get_libdir)/camera_hal/libcamera.so"
	fi
}
