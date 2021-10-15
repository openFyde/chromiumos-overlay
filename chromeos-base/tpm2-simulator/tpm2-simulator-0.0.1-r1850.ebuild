# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="aeb3663f1b1e4dce2b1fa51e4cf70a2c555ca17b"
CROS_WORKON_TREE=("2c293b25dd09e3deae29a0dd7d637fbc1cc44597" "deeecbada686d1b6013974abb12cad0ee364f6d7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk tpm2-simulator .gn"

PLATFORM_SUBDIR="tpm2-simulator"

inherit cros-workon platform user

DESCRIPTION="TPM 2.0 Simulator"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/tpm2-simulator/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/minijail:=
	dev-libs/openssl:0=
	"

RDEPEND="${COMMON_DEPEND}"
DEPEND="
	chromeos-base/tpm2:=[tpm2_simulator,tpm2_simulator_manufacturer]
	chromeos-base/vboot_reference:=[tpm2_simulator]
	${COMMON_DEPEND}
	"

src_install() {
	# Install init scripts
	insinto /etc/init
	doins init/tpm2-simulator.conf

	# Install executables
	dobin "${OUT}"/tpm2-simulator
	dobin "${OUT}"/tpm2-simulator-init
	dobin "${OUT}"/tpm2-simulator-stop

	# Install seccomp policy for cryptohome-proxy
	insinto /usr/share/policy
	newins "seccomp/tpm2-simulator-${ARCH}.policy" tpm2-simulator.policy
}

pkg_preinst() {
	enewuser tpm2-simulator
	enewgroup tpm2-simulator
}
