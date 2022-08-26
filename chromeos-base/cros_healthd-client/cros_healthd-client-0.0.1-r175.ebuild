# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e7441a07cb710f4410a6ce353734c49ef466b2fe"
CROS_WORKON_TREE=("9ca78a2d46421d17d297bbb13b05eebbb51d330a" "22e73209a1f442bdb7f51b01281a5e5bae946c16" "a977ac5a5f8c2b45bd2e89700fce8b695f10292c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk diagnostics/bindings diagnostics/mojom .gn"

PLATFORM_SUBDIR="diagnostics/mojom"

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

	# Install C++ headers.
	insinto /usr/include/cros_healthd-client/diagnostics/mojom/public
	doins "${S}"/public/*.mojom
	doins "${OUT}"/gen/include/diagnostics/mojom/public/*.h
	doins "${OUT}"/gen/include/diagnostics/mojom/public/*module

	insinto /usr/include/cros_healthd-client/diagnostics/mojom/external
	doins "${S}"/external/*.mojom
	doins "${OUT}"/gen/include/diagnostics/mojom/external/*.h
	doins "${OUT}"/gen/include/diagnostics/mojom/external/*module

	# Install libraries linked by the C++ headers.
	dolib.a "${OUT}"/*.a
}
