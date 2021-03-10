# Copyright (c) 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the BSD license.

EAPI=7
CROS_WORKON_COMMIT="85493d751a0a0b71cb7396ec5f412a8e0adc30a6"
CROS_WORKON_TREE="d1413b50615c7f886d833f35f1f7caa79a2d55ac"
CROS_WORKON_PROJECT="chromiumos/platform/touch_updater"
CROS_WORKON_LOCALNAME="touch_updater"
CROS_WORKON_SUBTREE="stupdate"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon user

DESCRIPTION="Wrapper for ST touch firmware updater."
HOMEPAGE="https://www.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/chromeos-touch-common
	sys-apps/st-touch-fw-updater
	!<chromeos-base/touch_updater-0.0.1-r167
"

pkg_preinst() {
	enewgroup fwupdate-i2c
	enewuser fwupdate-i2c
}

src_install() {
	exeinto "/opt/google/touch/scripts"
	doexe stupdate/scripts/*.sh

	if [ -d "stupdate/policies/${ARCH}" ]; then
		insinto "/opt/google/touch/policies"
		doins stupdate/policies/"${ARCH}"/*.policy
	fi
}
