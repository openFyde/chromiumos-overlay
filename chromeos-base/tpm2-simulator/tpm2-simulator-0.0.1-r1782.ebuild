# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0de749172817084d6c0867f1c9c4ce46b64c7c3d"
CROS_WORKON_TREE=("92fa6c1373050d9593236b88ef883cf2b7d0a85a" "bd13eabfc804c66584fba6988a8b836b170442d7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk tpm2-simulator .gn"

PLATFORM_SUBDIR="tpm2-simulator"

inherit cros-workon platform user

DESCRIPTION="TPM 2.0 Simulator"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/tpm2-simulator/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	dev-libs/openssl:0=
	"

RDEPEND="${COMMON_DEPEND}"
DEPEND="
	chromeos-base/tpm2:=
	${COMMON_DEPEND}
	"

src_install() {
	dobin "${OUT}"/tpm2-simulator
}
