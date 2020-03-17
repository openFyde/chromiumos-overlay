# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2c9f5f4dbbe7ab2e788961194484d975cbb9380f"
CROS_WORKON_TREE=("94bdce168a00f19903b3dd162e8e755cee9bbbf8" "a6d4fca3db878377b5ababec63bde6714fa580dc" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk secure_erase_file .gn"

PLATFORM_SUBDIR="secure_erase_file"

inherit cros-workon platform

DESCRIPTION="Secure file erasure for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/secure_erase_file/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
"

RDEPEND="
"

src_install() {
	dobin "${OUT}/secure_erase_file"
	dolib.so "${OUT}/lib/libsecure_erase_file.so"

	insinto /usr/include/chromeos/secure_erase_file
	doins secure_erase_file.h
}
