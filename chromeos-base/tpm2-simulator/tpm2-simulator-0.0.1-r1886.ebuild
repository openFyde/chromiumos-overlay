# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8052f629b7b97302f5cbd539f580d760e248b6c2"
CROS_WORKON_TREE=("59f8259ba32d739ab167ad0b7cfe950cd542b165" "30dbe432f5e7874ebed1557763eb0d2f7e311249" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	platform_install
}

pkg_preinst() {
	enewuser tpm2-simulator
	enewgroup tpm2-simulator
}
