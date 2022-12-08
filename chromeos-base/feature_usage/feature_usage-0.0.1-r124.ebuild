# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="275d66618708a79567dbec7b6034d5d08e291bcc"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "eac58977d9a19bc08a30206fdb76ae3b996724dd" "9c1a122c121b06b7f48cf0852ac656d255a739c1" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
