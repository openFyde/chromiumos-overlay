# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="8c4278e02adb2498b350ad32cc4c1e8507f887e6"
CROS_WORKON_TREE=("65d130298a29a5753f5a10122abad6b735ce2501" "bdd489c3c376247c2dd516e2e28d3a4bdc718eb6" "d0745d1765ae4f3bcb274b0b2ea28b4d78c666f8" "7f2d0530e333c2cfe5106b335fc2bff22ee483ca" "935a7c10e6d5aca87c2492012cc13fbb4ec62e91" "d1652e9fb58a3cbe06ef8d82574a2cb02d61799d" "d0745d1765ae4f3bcb274b0b2ea28b4d78c666f8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk trunks libhwsec metrics u2fd libhwsec-foundation libhwsec .gn"

PLATFORM_SUBDIR="u2fd"

inherit cros-workon platform user

DESCRIPTION="U2FHID Emulation Daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/u2fhid"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

COMMON_DEPEND="
	chromeos-base/attestation:=
	chromeos-base/attestation-client:=
	chromeos-base/cbor:=
	chromeos-base/libhwsec:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/power_manager-client:=
	chromeos-base/trunks:=
	dev-libs/hidapi:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/attestation-client:=
	>=chromeos-base/protofiles-0.0.43:=
	chromeos-base/system_api:=[fuzzer?]
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

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2f_apdu_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2fhid_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2f_msg_handler_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/u2fd_test_runner"
}
