# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("bd75b32a1035d7961813c03458871f40da44f68c" "417dfbf758a0a9c6d1ee65306f1ed48024959a03")
CROS_WORKON_TREE=("17e0c199bc647ae6a33554fd9047fa23ff9bfd7e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "bf8328d2dba3fd642f3cd2d72533a6071b7317b3")
CROS_WORKON_LOCALNAME=("platform2" "aosp/system/update_engine")
CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/system/update_engine")
CROS_WORKON_EGIT_BRANCH=("main" "master")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/update_engine")
CROS_WORKON_USE_VCSID=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="update_engine"

inherit cros-debug cros-workon platform systemd

DESCRIPTION="Chrome OS Update Engine"
HOMEPAGE="https://chromium.googlesource.com/aosp/platform/system/update_engine/"
SRC_URI=""

LICENSE="Apache-2.0"
KEYWORDS="*"
IUSE="cfm cros_host cros_p2p dlc fuzzer -hwid_override minios +power_management systemd"

COMMON_DEPEND="
	app-arch/bzip2:=
	chromeos-base/chromeos-ca-certificates:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/vboot_reference:=
	cros_p2p? ( chromeos-base/p2p:= )
	dev-libs/expat:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	dev-libs/xz-embedded:=
	dev-util/bsdiff:=
	dev-util/puffin:=
	net-misc/curl:=
	sys-apps/rootdev:="

DEPEND="
	app-arch/xz-utils:=
	chromeos-base/debugd-client:=
	dlc? ( chromeos-base/dlcservice-client:= )
	chromeos-base/power_manager-client:=
	chromeos-base/session_manager-client:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/update_engine-client:=
	test? ( sys-fs/squashfs-tools )
	${COMMON_DEPEND}"

DELTA_GENERATOR_RDEPEND="
	app-arch/unzip:=
	app-arch/xz-utils:=
	sys-libs/e2fsprogs-libs:=
	sys-fs/squashfs-tools
"

RDEPEND="
	!cros_host? ( chromeos-base/chromeos-installer )
	${COMMON_DEPEND}
	cros_host? ( ${DELTA_GENERATOR_RDEPEND} )
	power_management? ( chromeos-base/power_manager:= )
	virtual/update-policy:=
"

platform_pkg_test() {
	local unittests_binary="${OUT}"/update_engine_unittests

	# The unittests will try to exec `./helpers`, so make sure we're in
	# the right dir to execute things.
	cd "${OUT}"
	# The tests also want keys to be in the current dir.
	# .pub.pem files are generated on the "gen" directory.
	cp "${S}"/unittest_key*.pem ./ || die
	cp gen/include/update_engine/unittest_key*.pub.pem ./ || die

	# The unit tests check to make sure the minor version value in
	# update_engine.conf match the constants in update engine, so we need to be
	# able to access this file.
	cp "${S}/update_engine.conf" ./

	# If GTEST_FILTER isn't provided, we run two subsets of tests
	# separately: the set of non-privileged  tests (run normally)
	# followed by the set of privileged tests (run as root).
	# Otherwise, we pass the GTEST_FILTER environment variable as
	# an argument and run all the tests as root; while this might
	# lead to tests running with excess privileges, it is necessary
	# in order to be able to run every test, including those that
	# need to be run with root privileges.
	if [[ -z "${GTEST_FILTER}" ]]; then
		platform_test "run" "${unittests_binary}" 0 '-*.RunAsRoot*'
		platform_test "run" "${unittests_binary}" 1 '*.RunAsRoot*'
	else
		platform_test "run" "${unittests_binary}" 1 "${GTEST_FILTER}"
	fi

	for f in "omaha_request_action" "delta_performer"; do
		platform_fuzzer_test "${OUT}/update_engine_${f}_fuzzer"
	done
}

src_install() {
	dosbin "${OUT}"/update_engine
	dobin "${OUT}"/update_engine_client

	if use cros_host; then
		dobin "${OUT}"/delta_generator
	fi

	insinto /etc
	newins update_engine.conf.chromeos update_engine.conf

	if use systemd; then
		systemd_dounit "${FILESDIR}"/update-engine.service
		systemd_enable_service multi-user.target update-engine.service
	else
		# Install upstart script
		insinto /etc/init
		doins init/update-engine.conf
	fi

	# Install DBus configuration
	insinto /etc/dbus-1/system.d
	doins UpdateEngine.conf

	# TODO(b/182168271): Remove minios flag and public key from update_engine.
	# Add the public key only when signing for MiniOs.
	if use minios; then
		insinto "/build/initramfs"
		doins scripts/update_payload/update-payload-key.pub.pem
	fi

	platform_fuzzer_install "${S}"/OWNERS \
				"${OUT}"/update_engine_omaha_request_action_fuzzer \
				--dict "${S}"/fuzz/xml.dict
	platform_fuzzer_install "${S}"/OWNERS \
				"${OUT}"/update_engine_delta_performer_fuzzer
}
