# Copyright 2022 The ChromiumOS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="89d3c0078a4dabc9e83b2e6d0273d6f2e2a53908"
CROS_WORKON_TREE=("f063c143da4054868aadc5be54cc3a45415a698e" "68c5856b61e2d687811540861f5d8cd35be7572b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk faced .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="faced"

inherit cros-workon platform user

DESCRIPTION="Face authentication Daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/faced/README.md"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="
"

COMMON_DEPEND="
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api:=
"

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
