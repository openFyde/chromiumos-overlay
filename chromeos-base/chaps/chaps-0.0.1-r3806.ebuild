# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="90fe1b8615891fff847c98ce3434ad770c7e4fdf"
CROS_WORKON_TREE=("52639708fb7bf1a26ac114df488dc561a7ca9f3c" "74ab37d762af4bd568f50ac7c6112b807affae1b" "6e9c26cb7b02cc6f50dd851146140fd180437202" "d1d7e3ee195fa8851737c7be406928e3da6fedd0" "eb510d666a66e6125e281499b649651b849a25f7" "ba156cb5c59df9e2fb6e3a6bfd5105ab1264fe5a" "44b533b9e904bd46af6027adeb73b2256de03173" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_USE_VCSID=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk chaps libhwsec libhwsec-foundation metrics trunks tpm_manager .gn"

PLATFORM_SUBDIR="chaps"

inherit cros-workon platform systemd user

DESCRIPTION="PKCS #11 layer over TrouSerS"
HOMEPAGE="http://www.chromium.org/developers/design-documents/chaps-technical-design"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="systemd test tpm tpm_dynamic tpm_insecure_fallback tpm2 fuzzer"

REQUIRED_USE="
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

RDEPEND="
	tpm? (
		app-crypt/trousers:=
	)
	tpm2? (
		chromeos-base/trunks:=
	)
	chromeos-base/chaps-client:=
	chromeos-base/libhwsec:=[test?]
	chromeos-base/minijail:=
	chromeos-base/system_api:=[fuzzer?]
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/tpm_manager:=
	!dev-db/leveldb
	dev-libs/leveldb:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
"

# Note: We need dev-libs/nss and dev-libs/nspr for the pkcs11 headers.
DEPEND="${RDEPEND}
	test? (
		app-arch/gzip
		app-arch/tar
	)
	chromeos-base/system_api:=[fuzzer?]
	fuzzer? ( dev-libs/libprotobuf-mutator )
	tpm2? ( chromeos-base/trunks:=[test?] )
	dev-libs/nss:=
	dev-libs/nspr:=
	"

pkg_setup() {
	enewgroup "chronos-access"
	enewuser "chaps"
	cros-workon_pkg_setup
}

src_compile() {
	platform_src_compile

	# After compile, check the output for link dependency on nss.
	# We should NOT have any link dependency on nss because nss imports chaps.
	local out=$(scanelf -qRyn "${OUT}" | grep nss)
	[[ -n "${out}" ]] && die "No link dependency on nss allowed:\n${out}"
	# No dependency on nspr as well, same as above.
	out=$(scanelf -qRyn "${OUT}" | grep nspr)
	[[ -n "${out}" ]] && die "No link dependency on nspr allowed:\n${out}"
}

src_install() {
	platform_install

	# Install init scripts for systemd the ones for upstart are installd via
	# BUILD.gn.
	if use systemd; then
		systemd_dounit init/chapsd.service
		systemd_enable_service boot-services.target chapsd.service
		systemd_dotmpfilesd init/chapsd_directories.conf
	fi

	# Chaps keeps database inside the user's cryptohome.
	local daemon_store="/etc/daemon-store/chaps"
	dodir "${daemon_store}"
	fperms 0750 "${daemon_store}"
	fowners chaps:chronos-access "${daemon_store}"

	local fuzzer_component_id="1188704"
	local fuzzers=(
		chaps_attributes_fuzzer
		chaps_object_store_fuzzer
		chaps_utility_fuzzer
		chaps_slot_manager_fuzzer
		chaps_chaps_service_fuzzer
	)
	for fuzzer in "${fuzzers[@]}"; do
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/"${fuzzer}" \
			--comp "${fuzzer_component_id}"
	done
}

platform_pkg_test() {
	local tests=(
		chaps_test
		chaps_service_test
		slot_manager_test
		session_test
		object_test
		object_policy_test
		object_pool_test
		object_store_test
		isolate_login_client_test
	)
	use tpm2 && tests+=(
		tpm2_utility_test
	)

	local gtest_filter_qemu=""
	gtest_filter_qemu+="-*DeathTest*"
	gtest_filter_qemu+=":*ImportSample*"
	gtest_filter_qemu+=":TestSession.RSA*"
	gtest_filter_qemu+=":TestSession.KeyTypeMismatch"
	gtest_filter_qemu+=":TestSession.KeyFunctionPermission"
	gtest_filter_qemu+=":TestSession.BadKeySize"
	gtest_filter_qemu+=":TestSession.BadSignature.*"

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}" "" "" "${gtest_filter_qemu}"
	done
}

pkg_preinst() {
	local ug
	for ug in attestation pkcs11 chaps; do
		enewuser "${ug}"
		enewgroup "${ug}"
	done
}
