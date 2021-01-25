# Copyright (c) 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the BSD license.

EAPI=7
CROS_WORKON_COMMIT="648c32ee9be84808e2f36915883bf5e8e69c41c7"
CROS_WORKON_TREE="39ecd5f0368a99da0efe93d3209f59d658c5fa38"
CROS_WORKON_PROJECT="chromiumos/platform/touch_updater"
CROS_WORKON_LOCALNAME="touch_updater"
CROS_WORKON_SUBTREE="etphidiap"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon user

DESCRIPTION="Wrapper for etphidiap touch firmware updater."
HOMEPAGE="https://www.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/chromeos-touch-common
	sys-apps/etphidiap
	!<chromeos-base/touch_updater-0.0.1-r167
"

pkg_preinst() {
	enewgroup fwupdate-i2c
	enewuser fwupdate-i2c
}

src_install() {
	exeinto "/opt/google/touch/scripts"
	doexe etphidiap/scripts/*.sh

	if [ -d "etphidiap/policies/${ARCH}" ]; then
		insinto "/opt/google/touch/policies"
		doins etphidiap/policies/"${ARCH}"/*.policy
	fi
}
