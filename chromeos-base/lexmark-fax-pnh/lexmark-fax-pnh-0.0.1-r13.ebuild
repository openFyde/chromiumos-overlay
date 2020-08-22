# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("300292b66ec823232b046d9ee4fb24a5fc7d98fc" "66286b08bab6dc1bd60aa0746badf554b9278339")
CROS_WORKON_TREE=("a18be0e4067223084eb001e588d475448d48cd4c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c21e4f27dbf3f77743ca90efe4b116f6a95add73")
CROS_WORKON_LOCALNAME=("platform2" "third_party/lexmark-fax-pnh")
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
