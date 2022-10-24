# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="183de052a0a866d59f63be0ef22c957ea39f4277"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "49c9f1f378b14b31797c281f890cb6c9c5e1561f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	exeinto "${FIBOCOM_DIR}"
	cellular_dohelper "${OUT}/qc-modemfwd-helper"
}
