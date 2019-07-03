# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="99ee10a00bc62b49bbf582ec6ae9a4863bd2335f"
CROS_WORKON_TREE=("720f8e62a8429f6f1448b1aab7e27d406bf0b635" "061515cf7affefebd0beaceaff0182f80e24a84a" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libmems .gn"

PLATFORM_SUBDIR="libmems"

inherit cros-workon platform

DESCRIPTION="MEMS support library for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libmems"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo:=
	net-libs/libiio:="

DEPEND="${RDEPEND}
	chromeos-base/system_api"

src_install() {
	dolib.so "${OUT}/lib/libmems.so"
	dolib.so "${OUT}/lib/libmems_test_support.so"

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libmems.pc
	doins libmems_test_support.pc

	insinto "/usr/include/chromeos/libmems"
	doins *.h
}
