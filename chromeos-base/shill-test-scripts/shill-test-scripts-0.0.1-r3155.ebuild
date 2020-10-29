# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="dc73352d681464d3bffed1228498ce8c55a4eb92"
CROS_WORKON_TREE="2aeac53ba60c299115bae900809c074566d9228a"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="shill/test-scripts"

inherit cros-workon

DESCRIPTION="shill's test scripts"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/shill/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="python_targets_python2_7"

DEPEND="
	dev-lang/python
	dev-python/dbus-python
	python_targets_python2_7? ( dev-python/pygobject )"

RDEPEND="${DEPEND}
	>=chromeos-base/shill-0.0.1-r2205
	net-dns/dnsmasq
	sys-apps/iproute2"

src_compile() {
	# We only install scripts here, so no need to compile.
	:
}

src_install() {
	exeinto /usr/lib/flimflam/test
	doexe shill/test-scripts/*
}
