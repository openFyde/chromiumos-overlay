# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="855248a9bd9678de4f8b2a61eba2349e10289797"
CROS_WORKON_TREE=("f834e7e40228b458c4100226f262117a9d85cdb3" "3dc27fd4779c86257b3e8e77f08dce80472acc1e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
