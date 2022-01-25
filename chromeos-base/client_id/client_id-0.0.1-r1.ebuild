# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9977ab06d06a8a85bc6cf88ae1abdd9235d47637"
CROS_WORKON_TREE=("e5822571db2e92a58bc12dacc8e5042494372d19" "4134ee3d1ed21bd01adc8e007d3c9751f4bc2f1d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
