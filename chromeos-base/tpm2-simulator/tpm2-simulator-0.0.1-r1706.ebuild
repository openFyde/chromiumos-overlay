# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="afd98dcd1de1bb1daf9436e16658021345a8d1e3"
CROS_WORKON_TREE=("142f8e8618a85124529b0000717d72079aa4ad97" "2267c682d8423a037d456c9849122ce387e85e20" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
