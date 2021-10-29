# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="91d24f3a2ab509418bcca3e174a3b779744f0afa"
CROS_WORKON_TREE=("f9c9ff0f07a0e5d4015af871a558204de304bb90" "1a305e65cfaf27dd42734a37eda080d40b377d6c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
