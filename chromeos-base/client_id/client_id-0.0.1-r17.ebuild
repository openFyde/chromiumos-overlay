# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="5d9e35b8aed6e1af82447620cd2dfb0102e5a7b1"
CROS_WORKON_TREE=("a1485b27500f3f8a7cf4204d77b152d1c173e313" "44fee33df1d1e1d19aa6078be1f5c33590102ac8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk client_id .gn"

PLATFORM_SUBDIR="client_id"

inherit cros-workon platform

DESCRIPTION="Utility to generate Client ID for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/client_id"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

src_install() {
	dobin "${OUT}"/client_id
}

platform_pkg_test() {
	platform_test "run" "${OUT}/client_id_test"
}
