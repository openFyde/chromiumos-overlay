# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("81c85c7ca40e9e50f90d05d741f3bd385c3f8448" "f131d8f851366e6a2f8e8fa8f3042285d021d6c6")
CROS_WORKON_TREE=("c70c24e7eeb0c8aad6108bedde29b6984f63cd54" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4c04b0ebf35112629d2f6bc7e478514dcb5805cb")
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
