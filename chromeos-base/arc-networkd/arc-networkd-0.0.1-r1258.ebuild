# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="9db1b8858904aca5e3b2a81ab7313880c3790c6e"
CROS_WORKON_TREE=("490ca454234851e3d93af0e5b95c6ca36400a09f" "9d695cbc6ead9e21473dba14f31b98ae975a4a25")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/network"

PLATFORM_SUBDIR="arc/network"
PLATFORM_GYP_FILE="arc-network.gyp"

inherit cros-workon libchrome platform user

DESCRIPTION="ARC connectivity management daemon"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/libbrillo
	dev-libs/protobuf
	net-libs/libndp
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-nat-init
	net-misc/bridge-utils
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/shill-client
	chromeos-base/system_api
"

src_install() {
	# Main binary.
	dobin "${OUT}"/arc-networkd

	insinto /etc/init
	doins "${S}"/init/arc-network.conf
	doins "${S}"/init/arc-network-bridge.conf
}

pkg_preinst() {
	# Service account used for privilege separation.
	enewuser arc-networkd
	enewgroup arc-networkd
}
