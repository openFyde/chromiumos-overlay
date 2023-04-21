# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3908693468ed64d3140ff4c24e57f200005b2317"
CROS_WORKON_TREE=("c5a3f846afdfb5f37be5520c63a756807a6b31c4" "b6cd045bdddf1a135dc29dc12d81d0feef574be2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
