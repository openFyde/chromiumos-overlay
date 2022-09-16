# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9f1d8d5635b7ec53dd7db7fd9933fff66988a459"
CROS_WORKON_TREE=("52639708fb7bf1a26ac114df488dc561a7ca9f3c" "8dfd906269d58ed120d71e17a40620de501668ce" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_install

	dotmpfiles tmpfiles.d/*.conf
}
