# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0820492ee68f354de8640570fa57daa5e24ef0d6"
CROS_WORKON_TREE=("e747749e00f36b7c255da2376d5f0e9989bcd2f9" "7a0acd4e856e25ee560d96bb7acfa1d6e265df79" "fb8e41991af9e4c6c88768b137a9b48e4e5e47da" "9996ca2269ab80ee2f1c97dcde4afde657b17581" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk kerberos libpasswordprovider metrics .gn"

PLATFORM_SUBDIR="kerberos"

inherit cros-workon platform user

DESCRIPTION="Requests and manages Kerberos tickets to enable Kerberos SSO"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/kerberos/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="asan fuzzer"

COMMON_DEPEND="
	app-crypt/mit-krb5:=
	chromeos-base/libbrillo:=[asan?,fuzzer?]
	chromeos-base/libpasswordprovider:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/minijail:=
	dev-libs/protobuf:=
	sys-apps/dbus:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/protofiles:=
	chromeos-base/session_manager-client:=
	chromeos-base/system_api:=[fuzzer?]
"

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs kerberosd.
	enewuser kerberosd
	enewgroup kerberosd
	enewuser kerberosd-exec
	enewgroup kerberosd-exec
	cros-workon_pkg_setup
}

src_install() {
	dosbin "${OUT}"/kerberosd

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Kerberos.conf

	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.Kerberos.service

	insinto /etc/init
	doins init/kerberosd.conf

	insinto /usr/share/policy
	newins seccomp/kerberosd-seccomp-"${ARCH}".policy kerberosd-seccomp.policy

	insinto /usr/share/cros/startup/process_management_policies
	doins setuid_restrictions/kerberosd_uid_allowlist.txt

	# Create daemon store folder prototype, see
	# https://chromium.googlesource.com/chromiumos/docs/+/HEAD/sandboxing.md#securely-mounting-cryptohome-daemon-store-folders
	local daemon_store="/etc/daemon-store/kerberosd"
	dodir "${daemon_store}"
	fperms 0770 "${daemon_store}"
	fowners kerberosd:kerberosd "${daemon_store}"

	# fuzzer_component_id is unknown/unlisted
	platform_fuzzer_install "${S}/OWNERS" "${OUT}"/config_parser_fuzzer \
		--dict "${S}"/config_parser_fuzzer.dict || die
}

platform_pkg_test() {
	local tests=(
		kerberos_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
