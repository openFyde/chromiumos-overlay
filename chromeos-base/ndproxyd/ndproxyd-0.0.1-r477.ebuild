# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cf001d32edb3b79b68b778e88dff6a9e22fd3555"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "f57d1518244a737771adea57d6430dd6b0f85b1a" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
