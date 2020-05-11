# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="0c4760a9fe3dc79c37ca9f631cad35f6eb491259"
CROS_WORKON_TREE=("beaa4ae826abb3520fd39561f6556ff65c85078d" "34b3594059ca997b56ca950d778bc68c6a67560c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk typecd .gn"

PLATFORM_SUBDIR="typecd"

inherit cros-workon platform user

DESCRIPTION="Chrome OS USB Type C daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/typecd/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

src_install() {
	dobin "${OUT}"/typecd
}

pkg_preinst() {
	enewuser typecd
	enewgroup typecd
}
