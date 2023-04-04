# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="53976e946ff67846962c80391d3946561c7f14d1"
CROS_WORKON_TREE=("5b87e97f3ddb9634fb1d975839c28e49503e94f8" "741c117e003b0b9f76726f6f8bb9b90b3f6a101c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
