# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Add amd64 termina VM to system for testing"
SRC_URI="gs://termina-component-testing/uprev-test/amd64/${PV}/guest-vm-base.tbz -> termina-vm-amd64-${PV}.tbz"

RESTRICT="nomirror"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64 x86"
S="${WORKDIR}"

RDEPEND="!!chromeos-base/termina-image-arm"

src_install() {
	# Install VM files.
	insinto /opt/google/vms/termina-test/
	doins "${WORKDIR}"/*
}
