# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="f8e07dae2ad8c152a76d7c76e3cbf9cf2471dcfb"
CROS_WORKON_TREE=("34ec149bfffef93be14397dd8372e9c1bdbe7bfe" "fda343644d509468f777bd4c0d2054daef34e9e9" "11f6aaa2391d33bf71589db668ed50eeacfcb461" "36884ef4db2509f1d974bb9ad97d25368c43ff99" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk trunks metrics u2fd .gn"

PLATFORM_SUBDIR="u2fd"

inherit cros-workon platform user

DESCRIPTION="U2FHID Emulation Daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/u2fhid"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/metrics
	chromeos-base/power_manager-client
	chromeos-base/trunks
	dev-libs/hidapi
	"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api
	"

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs the u2f user and group.
	enewuser "u2f"
	enewgroup "u2f"
	cros-workon_pkg_setup
}

src_install() {
	dobin "${OUT}"/u2fd

	insinto /etc/init
	doins init/*.conf

	insinto /etc/dbus-1/system.d
	doins org.chromium.U2F.conf

	local daemon_store="/etc/daemon-store/u2f"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners u2f:u2f "${daemon_store}"
}
