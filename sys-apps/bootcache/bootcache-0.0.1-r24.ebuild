# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="ebe3a0995e90026433ffc62b7aeed6cad1f28694"
CROS_WORKON_TREE="2c052a63c6348d04c72e58437c827447bf4f380a"
CROS_WORKON_PROJECT="chromiumos/platform/bootcache"
CROS_WORKON_LOCALNAME="../platform/bootcache"
CROS_WORKON_OUTOFTREE_BUILD=1
inherit cros-workon cros-common.mk

DESCRIPTION="Utility for creating store for boot cache"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/bootcache"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

src_configure() {
	asan-setup-env
	cros-common.mk_src_configure
}

src_install() {
	dosbin "${OUT}"/bootcache

	insinto /etc/init
	doins bootcache.conf
}
