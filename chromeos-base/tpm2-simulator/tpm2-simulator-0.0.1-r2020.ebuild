# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e6a684b73143a50b7ee8f829e7ed0f30d6bd2738"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "21062c1829e54d7fd9c93c72da70479bbe0785b3" "c2be01e946207d334d8bcee37bc68d1b7f3ae574" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk tpm2-simulator libhwsec-foundation .gn"

PLATFORM_SUBDIR="tpm2-simulator"

inherit cros-workon platform tmpfiles user

DESCRIPTION="TPM 2.0 Simulator"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/tpm2-simulator/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

IUSE="+biometrics_dev selinux ti50_onboard tpm tpm2 test tpm2_simulator tpm2_simulator_manufacturer"

COMMON_DEPEND="
	tpm? ( !test? ( dev-libs/libtpms:= ) )
	tpm2? (
		chromeos-base/tpm2:=[tpm2_simulator?]
		chromeos-base/tpm2:=[tpm2_simulator_manufacturer?]
	)
	test? ( chromeos-base/tpm2:=[test] )
	chromeos-base/libhwsec-foundation:=
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

pkg_preinst() {
	enewuser tpm2-simulator
	enewgroup tpm2-simulator
}

src_install() {
	platform_src_install

	dotmpfiles tmpfiles.d/*.conf
}
