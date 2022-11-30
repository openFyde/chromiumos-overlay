# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="99713d0b66a40e999e5c66f2fd9c33c96e5cf88e"
CROS_WORKON_TREE=("7c7d4170b01f9cd05a107c251a378c716ccd9d77" "e1a822ff753a5dde4483e0e19f71e73db87e10d7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk bootstat .gn"

PLATFORM_SUBDIR="bootstat"

inherit cros-workon platform

DESCRIPTION="Chrome OS Boot Time Statistics Utilities"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/bootstat/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	sys-apps/rootdev:=
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
"

platform_pkg_test() {
	platform test_all
}
