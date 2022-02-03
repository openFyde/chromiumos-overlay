# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="173280e56d1a113f70c6dff28905457bbfa353d3"
CROS_WORKON_TREE=("0a7b5a1cfae096f3966abbfff9976df8159f6343" "10f764401db70982b44cbc37bfa433e93eccc1c7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

IUSE="tpm tpm2"

COMMON_DEPEND="
	tpm? ( dev-libs/libtpms:= )
	tpm2? ( chromeos-base/tpm2:=[tpm2_simulator,tpm2_simulator_manufacturer] )
	chromeos-base/minijail:=
	chromeos-base/pinweaver:=
	chromeos-base/vboot_reference:=[tpm2_simulator]
	dev-libs/openssl:0=
	sys-libs/libselinux:=
	"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

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
