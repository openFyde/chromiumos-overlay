# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2b90193166fb8c822d37daebd48cb5eb7a18bd09"
CROS_WORKON_TREE="e6b33e20f50d3b9d2f6f9407bd3232418eb51378"
CROS_WORKON_PROJECT="chromiumos/platform/libevdev"
CROS_WORKON_USE_VCSID=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_LOCALNAME="platform/libevdev"

inherit cros-debug cros-sanitizers cros-workon cros-common.mk

DESCRIPTION="evdev userspace library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/libevdev"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-asan"

src_configure() {
	sanitizers-setup-env
	cros-common.mk_src_configure
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
}
