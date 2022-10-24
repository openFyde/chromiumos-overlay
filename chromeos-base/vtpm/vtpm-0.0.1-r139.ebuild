# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d06ee5c6766fa1204202955908ea7ad9ff0f04de"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "97f2134df4adee660d876bdcc0bdddf15de9c453" "509f705acf9ee31036f6e8936f78b44a5f76a995" "8641ca6cc0480d641865e7e85930e0d5ae93fd2a" "35ad348feb7b707fc278653b50d4a3945c1e3550" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk attestation tpm_manager trunks vtpm .gn"

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
