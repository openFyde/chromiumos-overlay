# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c4b55bed1e5e021d71d42194531995f62506da9e"
CROS_WORKON_TREE=("6350979dbc8b7aa70c83ad8a03dded778848025d" "604026ec11e8af9ffa462dfbeb96e531f285fa78" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk patchpanel .gn"

PLATFORM_SUBDIR="patchpanel/ndproxyd"

inherit cros-workon libchrome platform

DESCRIPTION="NDProxy daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/network/"
LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	dev-libs/protobuf:=
	chromeos-base/libbrillo:=
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
"
