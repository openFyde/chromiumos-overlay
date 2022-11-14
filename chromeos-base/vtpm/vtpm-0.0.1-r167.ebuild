# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fab3170274860fa39a5ce5e5d68ed5e9498bccb6"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "74e6b0116389382e7f3859387d0d0c6d29775bab" "484f1e2c34eac4f5bfd4daed8051252ce371f2a7" "db75597a3a702c90030f8f50dee1f1f79046be1a" "75c2873c91f7cfcba9fe46b3311f49b29310b480" "264ae8e8ad73ab221fc719e5faa59d8d73806d71" "b760835cd40f267aace75dec9a0704de70356bd5" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk attestation libhwsec-foundation metrics tpm_manager trunks vtpm .gn"

PLATFORM_SUBDIR="vtpm"

inherit cros-workon libchrome platform user

DESCRIPTION="Virtual TPM service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vtpm/"

LICENSE="Apache-2.0"
KEYWORDS="*"
IUSE="test"

RDEPEND="
	chromeos-base/attestation:=[test?]
	chromeos-base/system_api:=
	chromeos-base/tpm_manager:=
	chromeos-base/trunks:=
	"

DEPEND="
	${RDEPEND}
	chromeos-base/attestation-client:=
	chromeos-base/trunks:=[test?]
	"

pkg_preinst() {
	# Create user and group for vtpm.
	enewuser "vtpm"
	enewgroup "vtpm"
}

src_install() {
	platform_src_install
}

platform_pkg_test() {
	platform test_all
}
