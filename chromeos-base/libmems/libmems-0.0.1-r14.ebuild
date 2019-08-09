# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="f8e07dae2ad8c152a76d7c76e3cbf9cf2471dcfb"
CROS_WORKON_TREE=("34ec149bfffef93be14397dd8372e9c1bdbe7bfe" "d792b68acde66d5b8a87dfccc1a920314e89095b" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
