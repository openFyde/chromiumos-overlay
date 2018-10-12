# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="4601b90d0472ac826f1c11ec5a2c1fafb19192c5"
CROS_WORKON_TREE="307d9a37ab43d41833d9455c5725d2ce3fbbefce"
CROS_WORKON_PROJECT="chromiumos/platform/frecon"
CROS_WORKON_LOCALNAME="../platform/frecon"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-sanitizers cros-workon cros-common.mk toolchain-funcs

DESCRIPTION="Chrome OS KMS console (without DBUS support)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/frecon"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="virtual/udev
	media-libs/libpng:0=
	sys-apps/libtsm"

DEPEND="${RDEPEND}
	media-sound/adhd
	virtual/pkgconfig
	x11-libs/libdrm"

src_configure() {
	export DBUS=0
	export TARGET=frecon-lite
	sanitizers-setup-env
	cros-common.mk_src_configure
}
