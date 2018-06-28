# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5
CROS_WORKON_COMMIT="88fa9de2da926293577c69b90a2b2a891a344b9d"
CROS_WORKON_TREE="7ccfe310179dda9a8e50a7fe0d36ddedaf78b7d5"
CROS_WORKON_PROJECT="chromiumos/platform/newblue"
CROS_WORKON_LOCALNAME="newblue"
CROS_WORKON_INCREMENTAL_BUILD=1

inherit toolchain-funcs multilib cros-workon udev

DESCRIPTION="NewBlue Bluetooth stack"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/newblue"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_configure() {
	cros-workon_src_configure
}

src_test() {
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		emake test
	fi
}

src_install() {
	emake DESTDIR="${D}" libdir=/usr/"$(get_libdir)" install

	insinto /usr/"$(get_libdir)"/pkgconfig
	doins newblue.pc

	udev_dorules "${FILESDIR}"/50-newblue.rules
}
