# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit python subversion

DESCRIPTION="GYP, a tool to generates native build files."
HOMEPAGE="http://code.google.com/p/gyp/"
SRC_URI=""
ESVN_REPO_URI="http://gyp.googlecode.com/svn/trunk@${PV}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 arm"
IUSE=""

src_install() {
	dobin gyp
	insinto "/usr/$(get_libdir)/python$(python_get_version)/site-packages"
	doins -r pylib/gyp
}
