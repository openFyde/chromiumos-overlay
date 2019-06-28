# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="6ed1eea32f34b2ef5f0d88ba45eb728186c7458a"
CROS_WORKON_TREE="1e6634ea44f001977cafd3d625d873024698388d"
CROS_WORKON_PROJECT="chromiumos/platform/bootcache"
CROS_WORKON_LOCALNAME="../platform/bootcache"
CROS_WORKON_OUTOFTREE_BUILD=1
inherit cros-sanitizers cros-workon cros-common.mk

DESCRIPTION="Utility for creating store for boot cache"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/bootcache"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

src_configure() {
	sanitizers-setup-env
	cros-common.mk_src_configure
}

src_install() {
	dosbin "${OUT}"/bootcache

	insinto /etc/init
	doins bootcache.conf
}
