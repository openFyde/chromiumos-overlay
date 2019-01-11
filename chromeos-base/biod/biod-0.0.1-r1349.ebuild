# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="45041591bd6b64dafbcff1d871df29832c95927d"
CROS_WORKON_TREE=("2174922822266644c39b7b650dab64513453484e" "859d68da61b2b647061bd3e5f4b41e9381357365" "bb1e0b651b26e8442a744c61ed7633d032dac607" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk biod metrics .gn"

PLATFORM_SUBDIR="biod"

inherit cros-fuzzer cros-sanitizers cros-workon platform udev user

DESCRIPTION="Biometrics Daemon for Chromium OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/packages/biod"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp fuzzer"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/libchrome
	chromeos-base/metrics
	"

DEPEND="
	${RDEPEND}
	chromeos-base/chromeos-ec-headers
	chromeos-base/system_api
	"

pkg_setup() {
	enewuser biod
	enewgroup biod
}

src_install() {
	dobin "${OUT}"/biod

	dobin "${OUT}"/bio_crypto_init
	dobin "${OUT}"/bio_wash

	into /usr/local
	dobin "${OUT}"/biod_client_tool

	insinto /usr/share/policy
	if use seccomp ; then
		local seccomp_src_dir="init/seccomp"

		newins "${seccomp_src_dir}/biod-seccomp-${ARCH}.policy" \
			biod-seccomp.policy

		newins "${seccomp_src_dir}/bio-crypto-init-seccomp-${ARCH}.policy" \
			bio-crypto-init-seccomp.policy
	fi

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
}

platform_pkg_test() {
	platform_test "run" "${OUT}/biod_test_runner"
}
