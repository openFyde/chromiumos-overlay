# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Chrome OS Firmware virtual package"
HOMEPAGE="http://src.chromium.org"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="*"

IUSE="bootimage cros_ec zephyr_ec cros_ish"

RDEPEND="!bootimage? ( chromeos-base/chromeos-firmware-null )
	bootimage? ( sys-boot/chromeos-bootimage )
	cros_ec? ( chromeos-base/chromeos-ec )
	zephyr_ec? ( chromeos-base/chromeos-zephyr )
	cros_ish? ( chromeos-base/chromeos-ish )"

DEPEND="bootimage? ( sys-boot/chromeos-bootimage )
	cros_ec? ( chromeos-base/chromeos-ec )
	zephyr_ec? ( chromeos-base/chromeos-zephyr )
	cros_ish? ( chromeos-base/chromeos-ish )"
