# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit udev user

DESCRIPTION="Ebuild to support the Chrome OS Cr50 device."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/ec-utils
	!<chromeos-base/chromeos-cr50-0.0.1-r38
"

S="${WORKDIR}"

pkg_preinst() {
	enewuser "rma_fw_keeper"
	enewgroup "rma_fw_keeper"
	enewgroup "suzy-q"
}

src_install() {
	local files
	local f

	insinto /etc/init
	files=(
		cr50-metrics.conf
		cr50-result.conf
		cr50-update.conf
	)
	for f in "${files[@]}"; do
		doins "${FILESDIR}/${f}"
	done

	udev_dorules "${FILESDIR}"/99-cr50.rules

	exeinto /usr/share/cros
	files=(
		cr50-flash-log.sh
		cr50-get-name.sh
		cr50-read-rma-sn-bits.sh
		cr50-reset.sh
		cr50-set-board-id.sh
		cr50-set-sn-bits.sh
		cr50-update.sh
		cr50-verify-ro.sh
		tpm2-lock-space.sh
		tpm2-nv-utils.sh
		tpm2-read-space.sh
		tpm2-write-space.sh
	)
	for f in "${files[@]}"; do
		doexe "${FILESDIR}/${f}"
	done

	insinto /opt/google/cr50/ro_db
	doins "${FILESDIR}"/ro_db/*.db
}
