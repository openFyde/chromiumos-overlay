# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="7dd23ea8ea986d3a00744117860610343a2d5872"
CROS_WORKON_TREE=("d13b09da7e45ae9123e9dbb3e10105e7e5c36737" "d26891fa9a4fb058250c8cb1b32fbe6b8edfbfc1" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE="common-mk pwgtocanonij .gn"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="pwgtocanonij"

inherit cros-workon platform

DESCRIPTION="Canon print filters for CUPS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/pwgtocanonij/"
LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="net-print/cups"

DEPEND="${RDEPEND}"

src_install() {
	exeinto /usr/libexec/cups/filter
	doexe "${OUT}"/pwgtocanonij
}

platform_pkg_test() {
	platform test_all
}
