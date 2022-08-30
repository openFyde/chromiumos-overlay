# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f2f6b8108a332ff756fa190bb1bba54b09c7e217"
CROS_WORKON_TREE=("9cddaab94373bf5cc18d0c29b52822676e80d756" "21f33449b94f847d4c3165a7dd3a27adcc70be52" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

IUSE="selinux ti50_onboard tpm tpm2 test tpm2_simulator tpm2_simulator_manufacturer"

COMMON_DEPEND="
	tpm? ( !test? ( dev-libs/libtpms:= ) )
	tpm2? (
		chromeos-base/tpm2:=[tpm2_simulator?]
		chromeos-base/tpm2:=[tpm2_simulator_manufacturer?]
	)
	test? ( chromeos-base/tpm2:=[test] )
	chromeos-base/minijail:=
	chromeos-base/pinweaver:=
	ti50_onboard? ( !test? ( chromeos-base/ti50-emulator:= ) )
	chromeos-base/vboot_reference:=[tpm2_simulator?]
	dev-libs/openssl:0=
	sys-libs/libselinux:=
	"

RDEPEND="
	${COMMON_DEPEND}
	selinux? (
		chromeos-base/selinux-policy
	)
"
DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_install
}

pkg_preinst() {
	enewuser tpm2-simulator
	enewgroup tpm2-simulator
}
