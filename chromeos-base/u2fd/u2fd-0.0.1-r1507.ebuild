# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="d9d43a0414900ef0ac91d61ad9f0e9da7729787b"
CROS_WORKON_TREE=("e747749e00f36b7c255da2376d5f0e9989bcd2f9" "56abda1a0dcbe956350a0fea12f2d0fdf348a95e" "45b63340d6611cbb5410ff91681d4b21d562ccfc" "72e7465f6d4271944dc51daaa36ca7d7d073ec63" "68532c536f0fde9d7f1caf7787121b16afd02199" "14ea278c59597b6f2d689136556a44aaad8e22b1" "92700840b98c9930f09300eabce93899cf204aa3" "45b63340d6611cbb5410ff91681d4b21d562ccfc" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
