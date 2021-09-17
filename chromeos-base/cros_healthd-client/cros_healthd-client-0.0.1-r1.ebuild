# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a9aae9ac3c465e2921fa1488aa014fef46243835"
CROS_WORKON_TREE=("a3d79a5641e6cda7da95a9316f5d29998cc84865" "1ac53a2f6fc9a98869559a289eae01edce10702c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk diagnostics/mojo .gn"

PLATFORM_SUBDIR="diagnostics/mojo"

WANT_LIBBRILLO="no"
inherit cros-workon platform

DESCRIPTION="Chrome OS Mojo client for cros_healthd"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/diagnostics/mojo"

LICENSE="BSD-Google"
KEYWORDS="*"

src_install() {
	# Install package config.
	insinto /usr/"$(get_libdir)"/pkgconfig
	doins cros_healthd-client.pc

	# Install mojom files.
	insinto /usr/src/cros_healthd-client/mojom/
	doins "${S}"/*.mojom

	# Install mojom modules.
	insinto /usr/src/cros_healthd-client/modules/
	doins "${OUT}"/gen/include/mojo/*module

	# Install C++ headers.
	insinto /usr/include/cros_healthd-client/mojo
	doins "${OUT}"/gen/include/mojo/*.h

	# Install libraries linked by the C++ headers.
	dolib.a "${OUT}"/*.a
}
