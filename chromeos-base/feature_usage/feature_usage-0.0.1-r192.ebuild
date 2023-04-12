# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="410f3d5e668f715073f98e01459b5bcffaf65ab8"
CROS_WORKON_TREE=("8fad85aa9518e1a0f04272ae9e077c4a4036297d" "0a6d97056ccad46af343769331531b94a8113dd1" "be6b90ece8cba62df98f449a023b1a060f77a3b6" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

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
