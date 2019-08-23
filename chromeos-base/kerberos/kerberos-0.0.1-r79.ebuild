# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c60230e290048c05188d7cf9871fe98ac1624275"
CROS_WORKON_TREE=("730940d1ad982b0928be2d517a8583b66235e15e" "7798cf50add158c6172efa1258b4ebf2d800491f" "c73e1f37fdaafa35e9ffaf067aca34722c2144cd" "a66f5b821d000f3c6459816fb8208f2a8b654134" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk kerberos libpasswordprovider metrics .gn"

PLATFORM_SUBDIR="kerberos"

inherit cros-workon platform user

DESCRIPTION="Requests and manages Kerberos tickets to enable Kerberos SSO"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/kerberos/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="asan fuzzer"

RDEPEND="
	app-crypt/mit-krb5
	chromeos-base/libbrillo:=[asan?,fuzzer?]
	chromeos-base/libpasswordprovider
	chromeos-base/metrics
	chromeos-base/minijail
	dev-libs/protobuf:=
	dev-libs/dbus-glib
	sys-apps/dbus
"
DEPEND="
	${RDEPEND}
	chromeos-base/protofiles:=
	chromeos-base/session_manager-client
	chromeos-base/system_api:=
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
	doins setuid_restrictions/kerberosd_whitelist.txt

	# Create daemon store folder prototype, see
	# https://chromium.googlesource.com/chromiumos/docs/+/master/sandboxing.md#securely-mounting-cryptohome-daemon-store-folders
	local daemon_store="/etc/daemon-store/kerberosd"
	dodir "${daemon_store}"
	fperms 0770 "${daemon_store}"
	fowners kerberosd:kerberosd "${daemon_store}"

	platform_fuzzer_install "${S}/OWNERS" "${OUT}"/config_validator_fuzzer \
		--dict "${S}"/config_validator_fuzzer.dict || die
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
