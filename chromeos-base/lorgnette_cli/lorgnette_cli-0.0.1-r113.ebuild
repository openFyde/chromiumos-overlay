# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9a2de0d377fdae131802e2c260721d2203d78009"
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "6cd4ff205d00f5d48fc389f0cc5233245d151153" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk lorgnette .gn"

PLATFORM_SUBDIR="lorgnette"

inherit cros-workon platform

DESCRIPTION="Command line interface to scanning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/lorgnette"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"

RDEPEND="
	chromeos-base/lorgnette
"

src_install() {
	dobin "${OUT}"/lorgnette_cli
}
