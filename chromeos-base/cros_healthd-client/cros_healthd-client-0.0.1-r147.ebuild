# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0838dd8cb7238027a16743d7eb0c8e29de1df369"
CROS_WORKON_TREE=("4055d34d682d2a7ff6bc4285499301674c0779ab" "99ac1219a4c06bc1244a21f14d67ef49bddba17e" "365b2dbafe1a1ae1f0a3fa076c0a919e720785e2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
