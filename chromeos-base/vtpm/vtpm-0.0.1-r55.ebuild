# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8e8ebfc39897a79f11c1e9258d3787145d97b0cf"
CROS_WORKON_TREE=("1127da40f25ab9f6f6d1c708ffc1308fbfff5f0e" "f32d0e6b97c07ab3eb7b2a205bdb3085aba5448e" "0a9598deba4de10118e4af0dc50356739dd9eef3" "c3f848940e0a2d93b7fb902d66dbd68eb39543cf" "4198533796b010f6bab8fb1d02bc76599e675638" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	platform_install

	dotmpfiles tmpflies.d/vtpm.conf
}

platform_pkg_test() {
	platform test_all
}
