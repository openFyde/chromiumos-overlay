# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7471b00970062dd8d6cf57089309d17425cf175a"
CROS_WORKON_TREE=("f13fe6260d63162b9e22bba96b94c30874378934" "8dc48a2a7c13453773dc4277fb123bb2b9e56815" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk tpm2-simulator .gn"

PLATFORM_SUBDIR="tpm2-simulator"

inherit cros-workon platform user

DESCRIPTION="TPM 2.0 Simulator"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/tpm2-simulator/"

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

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/selinux-policy
"
DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_install
}

pkg_preinst() {
	enewuser tpm2-simulator
	enewgroup tpm2-simulator
}
