# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="a6988bb849f9c8c833f0aebb9a85abdf7d0cc6c2"
CROS_WORKON_TREE=("6c641b53b4b5716a2d4b30be39008ac06f727856" "9487cb70b8720982545a04ade6a4f464cdde53ac" "e907dc6953dd79a3958765c3f4e3948fde42d98d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
