# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3cb92ed2991f55ae79c371114b35290ac5f2b8f5"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "9a79a818ef3b2f881675f38895a2691aa1fed078" "191ec9f359d96553c1e1bb00d2fbba8d4cc45800" "eb510d666a66e6125e281499b649651b849a25f7" "e0af264b8154f25a6a947488a41a286745729db8" "60b1091e186fbe1f2554d2d0844d56c6c556e1e1" "738283c4a8ccaca24fd7b8aedd6461947cc699ba" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk attestation libhwsec-foundation metrics tpm_manager trunks vtpm .gn"

PLATFORM_SUBDIR="vtpm"

inherit tmpfiles cros-workon libchrome platform user

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

	dotmpfiles tmpflies.d/vtpm.conf
}

platform_pkg_test() {
	platform test_all
}
