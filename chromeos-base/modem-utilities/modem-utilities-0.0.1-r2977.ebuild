# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="35a85995e8aac3d700502064a0649dd1449d3ab1"
CROS_WORKON_TREE=("c7c0905a6b2404597933022decab6f4c5011aaf7" "4b621073e7dbff29430b38e7990dd043146a6d8e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk modem-utilities .gn"

PLATFORM_SUBDIR="modem-utilities"

inherit cros-workon tmpfiles platform

DESCRIPTION="Chromium OS modem utilities"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/modem-utilities/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	sys-apps/dbus:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_src_install

	dotmpfiles tmpfiles.d/*.conf
}
