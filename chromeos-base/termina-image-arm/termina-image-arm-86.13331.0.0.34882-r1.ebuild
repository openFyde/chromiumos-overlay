# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Add arm termina VM to system for testing"
SRC_URI="gs://termina-component-testing/uprev-test/arm/${PV}/guest-vm-base.tbz -> termina-vm-arm-${PV}.tbz"

RESTRICT="nomirror"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm arm64"
S="${WORKDIR}"

RDEPEND="!!chromeos-base/termina-image-amd64"

src_install() {
	# Install VM files.
	insinto /opt/google/vms/termina-test/
	doins "${WORKDIR}"/*
}
