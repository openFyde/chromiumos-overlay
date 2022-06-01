# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="200d966b5647a49ca460c18763fad1bceb447366"
CROS_WORKON_TREE=("d4469c62dab4018d72e6355d285651f2780df211" "8d334e13ee768ae278f11b187eb68d647931dea3" "12bbd542247aac252e1e4d9715c0cef094bb7b4c" "7226e3910790963c0810793db376ae53c9a32be5" "abf81062296aedaa44c83d03bab614e14e25500f" "79ca3f650e7176da7bdb47c12e72f2c87efc2bf3" "74305780a8891c8859d1535613a7a29e0b63fa34" "12bbd542247aac252e1e4d9715c0cef094bb7b4c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	cr50_onboard? (
		chromeos-base/trunks:=
		chromeos-base/u2fd-client:=
	)
	ti50_onboard? (
		chromeos-base/trunks:=
		chromeos-base/u2fd-client:=
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

	if use cr50_onboard || use ti50_onboard; then
		local fuzzer_component_id="1188704"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2f_apdu_fuzzer \
			--comp "${fuzzer_component_id}"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2fhid_fuzzer \
			--comp "${fuzzer_component_id}"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2f_msg_handler_fuzzer \
			--comp "${fuzzer_component_id}"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/u2f_webauthn_fuzzer \
			--comp "${fuzzer_component_id}"
	fi
}

platform_pkg_test() {
	platform_test "run" "${OUT}/u2fd_test_runner"
}
