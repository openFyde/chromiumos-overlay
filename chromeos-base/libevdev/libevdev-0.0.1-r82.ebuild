# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="58e091cd2132dff2283affacba17175964fa45d6"
CROS_WORKON_TREE="36d45015a70fa508f65011ff715aad905cb1a2d6"
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
SLOT="0/0"

src_configure() {
	sanitizers-setup-env
	cros-common.mk_src_configure
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
}
