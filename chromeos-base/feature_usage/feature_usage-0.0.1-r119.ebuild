# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="ad2046efb422cba41d618c2c02a03c79565772a1"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "eac58977d9a19bc08a30206fdb76ae3b996724dd" "5178d8bdd0a9a7b3876d52c1b3e17deb34aeb72d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk feature_usage metrics .gn"

PLATFORM_SUBDIR="feature_usage"

inherit cros-workon platform

DESCRIPTION="Provides a unified approach to report feature usage events"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/metrics:=
"

DEPEND="
	${RDEPEND}
"

src_install() {
	# Install the static library
	dolib.a "${OUT}"/libfeature_usage_static.a

	# Install the header
	insinto "/usr/include/feature_usage"
	doins feature_usage_metrics.h

	# Install the pc file
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}/obj/feature_usage/libfeature_usage.pc"
}

platform_pkg_test() {
	platform test_all
}
