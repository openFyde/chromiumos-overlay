# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fbb47f8cd3a31b001cb95cd14cc87f4d53be74dd"
CROS_WORKON_TREE=("791c6808b4f4f5f1c484108d66ff958d65f8f1e3" "8e29f11c718c4a832c570433a5cf1e5382d6576f" "4a99e178e9e5497bfea4c425656cd65141c4b4bb" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk authpolicy metrics .gn"

PLATFORM_SUBDIR="authpolicy"

inherit cros-workon platform user

DESCRIPTION="Provides authentication to LDAP and fetching device/user policies"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/authpolicy/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="+samba asan fuzzer"

COMMMON_DEPEND="
	app-crypt/mit-krb5:=
	chromeos-base/libbrillo:=[asan?,fuzzer?]
	>=chromeos-base/metrics-0.0.1-r3152:=
	>=chromeos-base/minijail-0.0.1-r1477:=
	dev-libs/protobuf:=
	samba? ( >=net-fs/samba-4.5.3-r6:= )
	sys-apps/dbus:=
	sys-libs/libcap:=
"
RDEPEND="${COMMMON_DEPEND}"
DEPEND="
	${COMMMON_DEPEND}
	>=chromeos-base/protofiles-0.0.45:=
	chromeos-base/session_manager-client:=
	chromeos-base/system_api:=[fuzzer?]
"

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs authpolicyd.
	enewuser "authpolicyd"
	enewgroup "authpolicyd"
	enewuser "authpolicyd-exec"
	enewgroup "authpolicyd-exec"
	cros-workon_pkg_setup
}

src_install() {
	dosbin "${OUT}"/authpolicyd
	dosbin "${OUT}"/authpolicy_parser
	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/org.chromium.AuthPolicy.conf
	insinto /etc/init
	doins etc/init/authpolicyd.conf
	insinto /usr/share/policy
	doins seccomp_filters/*.policy
	insinto /usr/share/cros/startup/process_management_policies
	doins setuid_restrictions/authpolicyd_whitelist.txt

	# Create daemon store folder prototype, see
	# https://chromium.googlesource.com/chromiumos/docs/+/master/sandboxing.md#securely-mounting-cryptohome-daemon-store-folders
	local daemon_store="/etc/daemon-store/authpolicyd"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners authpolicyd:authpolicyd "${daemon_store}"

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/preg_parser_fuzzer \
		--dict "${S}"/policy/testdata/preg_parser_fuzzer.dict
}

platform_pkg_test() {
	local tests=(
		authpolicy_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done

	platform_fuzzer_test "${OUT}"/preg_parser_fuzzer
}
