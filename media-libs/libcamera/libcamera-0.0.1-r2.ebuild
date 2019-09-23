# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="ad0a61e32ca54ddcb400bbb2d8396f15b10bda90"
CROS_WORKON_TREE="0754a2e318d29266ceed2b17e363a5e5edd7d3a0"
CROS_WORKON_PROJECT="chromiumos/third_party/libcamera"
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-workon meson

DESCRIPTION="Camera support library for Linux"
HOMEPAGE="https://www.libcamera.org"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="arc-camera3 doc test udev"

RDEPEND="udev? ( virtual/libudev )"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_use arc-camera3 android)
		$(meson_use doc documentation)
		$(meson_use test)
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
