# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c02184b9631f512180e18fe19036c5f5f8b9245b"
CROS_WORKON_TREE=("fd02e6090c8f07ce200c4a4a20eefc55a064dc6d" "7d0edff0bc8ff7c394d944fadc399ca567e9b1bf" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk tpm2-simulator .gn"

PLATFORM_SUBDIR="tpm2-simulator"

inherit cros-workon platform user

DESCRIPTION="TPM 2.0 Simulator"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	dev-libs/openssl:0=
	chromeos-base/libbrillo
	"

DEPEND="
	chromeos-base/tpm2
	${RDEPEND}
	"

src_install() {
	dobin "${OUT}"/tpm2-simulator
}
