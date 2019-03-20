# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5
CROS_WORKON_COMMIT="a30ed4274e058e8d69f3d1f74e72211285cf5f8a"
CROS_WORKON_TREE="b2416a17520db4488caf2cc1d6aac919bb8a5e04"
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
	elif [[ $(get-flag march) == amd* ]]; then
		# SSE4a optimization causes tests to not run properly on Intel bots.
		# https://crbug.com/856686
		elog "Skipping unit tests on AMD platform"
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
