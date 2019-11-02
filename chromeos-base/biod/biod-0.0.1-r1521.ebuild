# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="5b7c5ee0509fd988d20f56fbd6ba8d3386fb4bca"
CROS_WORKON_TREE=("70d83bbed2cc71b12ba96acb151f090af819c990" "eb2874b79c09cfe06cc47e53fc156b210a75c44b" "08a9d2628c2d6c2c3927546901c137c75a8d36d4" "0fb784e506cbf071c9e2700aa93bf591a4f624a1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk biod chromeos-config metrics .gn"

PLATFORM_SUBDIR="biod"

inherit cros-fuzzer cros-sanitizers cros-workon platform udev user

DESCRIPTION="Biometrics Daemon for Chromium OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/packages/biod"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="fp_on_power_button fuzzer unibuild"

RDEPEND="
	unibuild? ( chromeos-base/chromeos-config )
	chromeos-base/chromeos-config-tools
	chromeos-base/libbrillo:=
	chromeos-base/metrics:=
	sys-apps/flashmap:=
	sys-apps/flashrom
	virtual/chromeos-firmware-fpmcu
	"

DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-ec-headers
	chromeos-base/power_manager-client
	chromeos-base/system_api[fuzzer?]
	dev-libs/openssl:=
	"

pkg_setup() {
	enewuser biod
	enewgroup biod
}

src_install() {
	dobin "${OUT}"/biod

	dobin "${OUT}"/bio_crypto_init
	dobin "${OUT}"/bio_wash

	dosbin "${OUT}"/bio_fw_updater

	into /usr/local
	dobin "${OUT}"/biod_client_tool

	insinto /usr/share/policy
	local seccomp_src_dir="init/seccomp"

	newins "${seccomp_src_dir}/biod-seccomp-${ARCH}.policy" \
		biod-seccomp.policy

	newins "${seccomp_src_dir}/bio-crypto-init-seccomp-${ARCH}.policy" \
		bio-crypto-init-seccomp.policy

	insinto /etc/init
	doins init/*.conf

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.BiometricsDaemon.conf

	udev_dorules udev/99-biod.rules

	# Set up cryptohome daemon mount store in daemon's mount
	# namespace.
	local daemon_store="/etc/daemon-store/biod"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners biod:biod "${daemon_store}"

	platform_fuzzer_install "${S}/OWNERS" "${OUT}"/biod_storage_fuzzer

	platform_fuzzer_install "${S}/OWNERS" "${OUT}"/biod_crypto_validation_value_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/biod_test_runner"
}
