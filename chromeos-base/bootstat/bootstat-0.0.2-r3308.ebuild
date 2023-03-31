# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e364b159e56f23ece2af994214187c650908d14f"
CROS_WORKON_TREE=("04da1711dfcf3e15f8ffb8bc59e4fc277481515b" "edb8beb3d905ccdb7e057b1e8753a733721e6f15" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
