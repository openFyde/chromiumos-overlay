# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f3b0a0e7e65369dad5de6aa9fde695925933f2ef"
CROS_WORKON_TREE=("86b344aa22a65c4e51fe3ed174b097ce96f60cd6" "6c48d0b170d063b861d66ff2e38551667533ab6f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
