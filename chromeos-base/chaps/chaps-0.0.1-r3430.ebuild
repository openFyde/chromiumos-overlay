# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f13d8789b11ab3d0d8e4064e0dd4b6cfa510d212"
CROS_WORKON_TREE=("6b82b37113f6969a6645e19dabaeda0cb4e502d5" "569cc0dd6927f9732bf51915aaa88ab8a48b0bbf" "d0745d1765ae4f3bcb274b0b2ea28b4d78c666f8" "c32154ddfff8e0ed06738bee2835526d9d4d339b" "5666fc7e1ee7a8464bf7740216c02b8d117a7461" "dd44112820495ca7ea61c7861f9cfb4bde1580cd" "5acc35a68d774b89f4039d31a0efb6a5c0a3e85f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="systemd test tpm tpm_dynamic tpm2 fuzzer"

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
	dosbin "${OUT}"/chapsd
	dobin "${OUT}"/chaps_client
	dobin "${OUT}"/p11_replay
	dolib.so "${OUT}"/lib/libchaps.so

	# Install D-Bus config file.
	dodir /etc/dbus-1/system.d
	sed 's,@POLICY_PERMISSIONS@,group="pkcs11",' \
		"org.chromium.Chaps.conf.in" \
		> "${D}/etc/dbus-1/system.d/org.chromium.Chaps.conf"

	# Install init scripts.
	if use systemd; then
		if use tpm2; then
			sed 's/tcsd.service/trunksd.service' \
				init/chapsd.service \
				> "${T}/chapsd.service"
			systemd_dounit "${T}/chapsd.service"
		else
			systemd_dounit init/chapsd.service
		fi
		systemd_enable_service boot-services.target chapsd.service
		systemd_dotmpfilesd init/chapsd_directories.conf
	else
		insinto /etc/init
		doins init/chapsd.conf
		if use tpm2; then
			sed -i 's/started tcsd/started trunksd/' \
				"${D}/etc/init/chapsd.conf" ||
				die "Can't replace tcsd with trunksd in chapsd.conf"
		fi
	fi
	exeinto /usr/share/cros/init

	# Install headers for use by clients.
	insinto /usr/include/chaps
	doins token_manager_client.h
	doins token_manager_client_mock.h
	doins token_manager_interface.h
	doins isolate.h
	doins chaps_proxy_mock.h
	doins chaps_interface.h
	doins chaps.h
	doins attributes.h

	# Install live tests
	if use test; then
		dosbin "${OUT}"/chapsd_test
		dosbin "${OUT}"/tpm_utility_test
	fi

	insinto /usr/include/chaps/pkcs11
	doins pkcs11/*.h

	# Chaps keeps database inside the user's cryptohome.
	local daemon_store="/etc/daemon-store/chaps"
	dodir "${daemon_store}"
	fperms 0750 "${daemon_store}"
	fowners chaps:chronos-access "${daemon_store}"

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/chaps_attributes_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/chaps_object_store_fuzzer
}

platform_pkg_test() {
	local tests=(
		chaps_test
		chaps_service_test
		dbus_test
		slot_manager_test
		session_test
		object_test
		object_policy_test
		object_pool_test
		object_store_test
		opencryptoki_importer_test
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
