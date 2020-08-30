# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the BSD license.

EAPI="7"

CROS_WORKON_COMMIT="f031e2d6a1c23615e945435faf4861f3da233ea8"
CROS_WORKON_TREE="b349f1dab647f2028f8451aef030805eb8a13e64"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="chromeos-nvt-tcon-updater"

inherit cros-workon user

DESCRIPTION="Shell library for integrating the Novatek TCON Firmware updater"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/chromeos-init
	chromeos-base/common-assets
	chromeos-base/minijail
	sys-apps/novatek-tcon-fw-update-tool
"

pkg_preinst() {
	enewgroup fwupdate-drm_dp_aux-i2c
	enewuser fwupdate-drm_dp_aux-i2c
}

src_install() {
	insinto "/opt/google/tcon/policies"
	doins chromeos-nvt-tcon-updater/policies/"${ARCH}"/nvt-tcon-fw-updater.update.policy

	insinto "/opt/google/tcon/scripts"
	doins chromeos-nvt-tcon-updater/scripts/chromeos-nvt-tcon-firmware-update.sh
}
