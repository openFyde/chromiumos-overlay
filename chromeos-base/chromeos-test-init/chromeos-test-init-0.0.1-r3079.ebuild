# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="a1ff2472b257de3d5ec19609ddb374eeaa0a283b"
CROS_WORKON_TREE="12a560ba2232d503dc1634b6be50c0cc7dc7514b"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_SUBTREE="init"

inherit cros-workon

DESCRIPTION="Additional upstart jobs that will be installed on test images"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="X"

src_unpack() {
	cros-workon_src_unpack
	S+="/init"
}

src_install() {
	insinto /etc/init
	doins upstart/test-init/*.conf
	dosbin upstart/test-init/job-filter

	insinto /usr/share/cros
	doins upstart/test-init/*_utils.sh

	use X || rm -f "${D}"/etc/init/vnc.conf
}

