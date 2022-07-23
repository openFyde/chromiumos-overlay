# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="09c5bc2d23a4e625fdd74032e385e630e9caa0bb"
CROS_WORKON_TREE=("e7f63c823468db13a24ebe2323042c054c4316c9" "9aa53224feae9d99553363514bd87a0ab5617afd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
