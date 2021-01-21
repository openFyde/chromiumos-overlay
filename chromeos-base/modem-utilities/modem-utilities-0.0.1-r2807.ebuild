# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0386b7270f0844b727a0bb79efd37a799c65fd59"
CROS_WORKON_TREE="08fef9bfa37519ae02be747b71f1b2ecfcb9839b"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="modem-utilities"

inherit cros-workon

DESCRIPTION="Chromium OS modem utilities"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/modem-utilities/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	sys-apps/dbus:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_unpack() {
	cros-workon_src_unpack
	S+="/modem-utilities"
}
