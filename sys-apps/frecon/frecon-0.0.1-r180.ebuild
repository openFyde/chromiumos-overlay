# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e3be588f800b9b46ef4dc788f4179eb39943cccd"
CROS_WORKON_TREE="519b947b77027c58fc7878f0340a09fd936f4e6f"
CROS_WORKON_PROJECT="chromiumos/platform/frecon"
CROS_WORKON_LOCALNAME="../platform/frecon"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-sanitizers cros-workon cros-common.mk

DESCRIPTION="Chrome OS KMS console"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/frecon"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-asan"

BDEPEND="virtual/pkgconfig"

COMMON_DEPEND="virtual/udev
	sys-apps/dbus:=
	media-libs/libpng:0=
	sys-apps/libtsm:=
	x11-libs/libdrm:="

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	media-sound/adhd:=
"

src_configure() {
	sanitizers-setup-env
	cros-common.mk_src_configure
}

src_install() {
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.frecon.conf
	default
}
