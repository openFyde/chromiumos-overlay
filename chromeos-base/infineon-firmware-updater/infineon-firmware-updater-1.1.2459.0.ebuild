# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Infineon TPM firmware updater"
SRC_URI="gs://chromeos-localmirror/distfiles/${P}.tar.gz"

LICENSE="BSD-Infineon LICENSE.infineon-firmware-updater-TCG"
SLOT="0"
KEYWORDS="*"
IUSE="tpm_slb9655_v4_31"

RDEPEND="
	dev-libs/openssl
	tpm_slb9655_v4_31? ( chromeos-base/ec-utils )
"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/makefile-fixes.patch
	epatch "${FILESDIR}"/unlimited-log-file-size.patch
	epatch "${FILESDIR}"/dry-run-option.patch
	epatch "${FILESDIR}"/change_default_password.patch
	epatch "${FILESDIR}"/retry-send-on-ebusy.patch
	epatch "${FILESDIR}"/ignore-error-on-complete-option.patch
}

src_configure() {
	tc-export AR CC
}

src_compile() {
	emake -C TPMFactoryUpd
}

src_install() {
	newsbin TPMFactoryUpd/TPMFactoryUpd infineon-firmware-updater
	dosbin "${FILESDIR}"/tpm-firmware-updater

	insinto /etc/init
	doins "${FILESDIR}"/tpm-firmware-update.conf
	doins "${FILESDIR}"/send-tpm-firmware-update-metrics.conf
	exeinto /usr/share/cros/init
	doexe "${FILESDIR}"/tpm-firmware-update.sh
	doexe "${FILESDIR}"/tpm-firmware-update-factory.sh
}
