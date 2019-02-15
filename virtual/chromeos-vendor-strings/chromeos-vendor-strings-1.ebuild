# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Vendor firmware strings virtual package"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="sys-boot/chromeos-vendor-strings-null"
RDEPEND="${DEPEND}"
