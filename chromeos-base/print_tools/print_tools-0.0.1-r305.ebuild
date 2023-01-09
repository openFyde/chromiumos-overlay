# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f95e5b236e0dd2d58f670416439986a4d0548a85"
CROS_WORKON_TREE=("eb1fe3bef742a865c350a9d742e224d4077efbd5" "06444dec030cf5a6b8cd24706f6eb5432c16d4d2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk print_tools .gn"

PLATFORM_SUBDIR="print_tools"

inherit cros-workon platform

DESCRIPTION="Various tools for the native printing system."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/print_tools/"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/libipp:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_src_install

	dobin "${OUT}"/printer_diag
}

platform_pkg_test() {
	platform test_all
}
