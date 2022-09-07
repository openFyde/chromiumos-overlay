# Copyright 2022 The ChromiumOS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="95e6fc60096e208e9c3f38cab8e41066fbb65bde"
CROS_WORKON_TREE=("cfee39c602b1e7245b488e40b8e6c51a32658e5f" "68c5856b61e2d687811540861f5d8cd35be7572b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

pkg_setup() {
	# Create the "faced" user and group in pkg_setup instead of pkg_preinst
	# in order to mount cryptohome daemon store
	enewuser "faced"
	enewgroup "faced"
	cros-workon_pkg_setup
}

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
