# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fd36353beb579720cc1b091c7e1438aa6522c8ab"
CROS_WORKON_TREE="cd492a2722078527b7f6c555435a6d2a6880cf80"
CROS_WORKON_PROJECT="chromiumos/platform/frecon"
CROS_WORKON_LOCALNAME="../platform/frecon"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-sanitizers cros-workon cros-common.mk

DESCRIPTION="Chrome OS KMS console (without DBUS/UDEV support)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/frecon"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-asan"

BDEPEND="virtual/pkgconfig"

COMMON_DEPEND="media-libs/libpng:0=
	sys-apps/libtsm:="

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	media-sound/adhd:=
	x11-libs/libdrm:="

src_configure() {
	export FRECON_LITE=1
	sanitizers-setup-env
	cros-common.mk_src_configure
}
