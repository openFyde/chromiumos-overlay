# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="422e3e92ada16946dd3519f140edf51884bcca32"
CROS_WORKON_TREE="cf1229f4159179f404b807467fb32fc2011d3ad3"
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
