# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="9a1e71b8a169930c3be06fb71ab01db67588d689"
CROS_WORKON_TREE="ec155b12fedb91ea9065204ec5240385555278ea"
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
