# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="c93e3d09f9b5694fe75418354b3d9305d7a84870"
CROS_WORKON_TREE=("fc0efcf57b9c4608c99ba94900299fe22d46d881" "980093cbacead987ae1ed7a106508eec6c4eac80" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
