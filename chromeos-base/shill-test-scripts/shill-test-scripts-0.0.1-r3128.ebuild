# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="55eb4bfce13c52feadcff59d83918ae49f84014f"
CROS_WORKON_TREE="23b716e8740580109bc66f929a4d2c1493b80011"
CROS_WORKON_LOCALNAME="aosp/system/connectivity/shill"
CROS_WORKON_PROJECT="aosp/platform/system/connectivity/shill"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-workon

DESCRIPTION="shill's test scripts"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="!!chromeos-base/flimflam-test
	dev-lang/python
	dev-python/dbus-python
	dev-python/pygobject"

RDEPEND="${DEPEND}
	chromeos-base/shill
	net-dns/dnsmasq
	sys-apps/iproute2"

src_compile() {
	# We only install scripts here, so no need to compile.
	:
}

src_install() {
	exeinto /usr/lib/flimflam/test
	doexe test-scripts/*
}
