# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e364b159e56f23ece2af994214187c650908d14f"
CROS_WORKON_TREE=("04da1711dfcf3e15f8ffb8bc59e4fc277481515b" "4ff9d77bcfe6211ffc719efe30602e383139fb8d" "1b7c0dc4cdbecebdb3f33b58bbc32efd52a138ba" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

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
