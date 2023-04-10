# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="02ef5eac318fbda1448b20661ecb5602d8d1c36f"
CROS_WORKON_TREE=("5b87e97f3ddb9634fb1d975839c28e49503e94f8" "be22dd8cfa5b3c0fad48248c8dcbd852fae626b8" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
