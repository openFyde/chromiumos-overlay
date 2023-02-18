# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="70e2e58f11c6b8c8f989d147db017cd93521462e"
CROS_WORKON_TREE=("8691d18b0a605890aebedfd216044cfc57d81571" "7dc1ff39293b690309dfe977bab09869d6c602be" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk modemfwd .gn"

PLATFORM_SUBDIR="modemfwd/helpers/qc-modemfwd-helper"

inherit cros-cellular cros-workon platform

DESCRIPTION="modemfwd helper for Qualcomm modems"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/modemfwd"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

RDEPEND="
"

DEPEND="${RDEPEND}"

FIBOCOM_DIR="/opt/fibocom"

src_install() {
	platform_src_install

	exeinto "${FIBOCOM_DIR}"
	cellular_dohelper "${OUT}/qc-modemfwd-helper"
}
