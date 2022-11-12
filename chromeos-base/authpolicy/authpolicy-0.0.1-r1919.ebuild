# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="86f82959d89cca3216d606eb613665dfa27026f1"
CROS_WORKON_TREE=("684de7632fb3bf23e07149db10c51780f7a80c39" "c658ef57d46196c8313c5be6bd9a9bef14c88d53" "da1fba0069ab3fbe644d71ecaa3ce8f5a5693a49" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk authpolicy metrics .gn"

PLATFORM_SUBDIR="authpolicy"

inherit cros-workon platform user

DESCRIPTION="Provides authentication to LDAP and fetching device/user policies"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/authpolicy/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="+samba asan fuzzer"

COMMMON_DEPEND="
	app-crypt/mit-krb5:=
	chromeos-base/cryptohome-client:=
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
	>=chromeos-base/protofiles-0.0.75:=
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
	platform_src_install

	# Create daemon store folder prototype, see
	# https://chromium.googlesource.com/chromiumos/docs/+/HEAD/sandboxing.md#securely-mounting-cryptohome-daemon-store-folders
	local daemon_store="/etc/daemon-store/authpolicyd"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners authpolicyd:authpolicyd "${daemon_store}"

	# fuzzer_component_id is unknown/unlisted
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/preg_parser_fuzzer \
		--dict "${S}"/policy/testdata/preg_parser_fuzzer.dict
}

platform_pkg_test() {
	platform test_all
	platform_fuzzer_test "${OUT}"/preg_parser_fuzzer
}
