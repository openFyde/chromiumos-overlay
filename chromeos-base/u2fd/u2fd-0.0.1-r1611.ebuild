# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9f4f09de46f3ae2411064f72b941ad3cb0242060"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "60b1091e186fbe1f2554d2d0844d56c6c556e1e1" "f250e2e5dae7246259afcc2498581e4c62deee31" "49f17dd26f6eb6be59009adab6aa79f3bddbb940" "e0af264b8154f25a6a947488a41a286745729db8" "78e2afb8dbfa561ddaa5ef95759112bcff96873f" "191ec9f359d96553c1e1bb00d2fbba8d4cc45800" "f250e2e5dae7246259afcc2498581e4c62deee31" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk trunks libhwsec metrics tpm_manager u2fd libhwsec-foundation libhwsec .gn"

PLATFORM_SUBDIR="u2fd"

inherit cros-workon platform user

DESCRIPTION="U2FHID Emulation Daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/u2fd/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer tpm cr50_onboard ti50_onboard"

COMMON_DEPEND="
	tpm? (
		app-crypt/trousers:=
	)
	fuzzer? (
		chromeos-base/trunks:=
	)
	cr50_onboard? (
		chromeos-base/trunks:=
	)
	ti50_onboard? (
		chromeos-base/trunks:=
	)
	chromeos-base/attestation:=
	chromeos-base/attestation-client:=
	chromeos-base/cbor:=
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/cryptohome-client:=
	chromeos-base/libhwsec:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/power_manager-client:=
	chromeos-base/session_manager-client:=
	chromeos-base/tpm_manager:=
	chromeos-base/u2fd-client:=
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

	local fuzzer_component_id="1188704"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2f_apdu_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2fhid_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2f_msg_handler_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2f_webauthn_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/u2fd_test_runner"
}
