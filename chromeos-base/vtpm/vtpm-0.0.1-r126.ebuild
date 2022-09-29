# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="61ec7b6c83df3c40e70beef2582357189061f820"
CROS_WORKON_TREE=("9706471f3befaf4968d37632c5fd733272ed2ec9" "e9c575048e12519f339c1d0b8d13926533cb3b40" "509f705acf9ee31036f6e8936f78b44a5f76a995" "0744892ba40d23c2672468cfb7f5e3550d8644a5" "ebbbbce576a78fcee986245ab79ed871b174b923" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
