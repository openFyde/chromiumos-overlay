# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("416bbc632306c288e0c1d9a3e9aeeec147f38d42" "f131d8f851366e6a2f8e8fa8f3042285d021d6c6")
CROS_WORKON_TREE=("508cf7a0cbe92241c6bbdfd45a0547005902b442" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "4c04b0ebf35112629d2f6bc7e478514dcb5805cb")
CROS_WORKON_LOCALNAME=("platform2" "third_party/lexmark-fax-pnh")
CROS_WORKON_EGIT_BRANCH=("main" "master")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/third_party/lexmark-fax-pnh")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/lexmark-fax-pnh")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="lexmark-fax-pnh"

inherit cros-workon platform

DESCRIPTION="ChromeOS implementation of the Lexmark fax-pnh-filter"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/lexmark-fax-pnh/"

LICENSE="MPL-2.0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	net-print/cups
"
DEPEND="${RDEPEND}"

platform_pkg_test() {
	platform_test "run" "${OUT}/token_replacer_testrunner"
}

src_install() {
	exeinto /usr/libexec/cups/filter
	doexe "${OUT}"/fax-pnh-filter
}
