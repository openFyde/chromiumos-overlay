# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="51bbb1151fccf54a71a8aa9123fb8d25e634af7e"
CROS_WORKON_TREE=("5aa2bdc92600cbba67b37a455ef2bedb6334c1ad" "92710594a4e885f4fd4d6c3167e8e46963586723" "0c2081c780413b877b6cb8f0cd1418786a793c73" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk biod metrics .gn"

PLATFORM_SUBDIR="biod"

inherit cros-workon platform udev user

DESCRIPTION="Biometrics Daemon for Chromium OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/packages/biod"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

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
}

platform_pkg_test() {
	platform_test "run" "${OUT}/biod_test_runner"
}
