# Copyright (c) 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Chrome OS BSP config virtual package"
HOMEPAGE="http://src.chromium.org"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="*"

IUSE=""

# TODO(bmgordon): Remove chromeos-base/chromeos-config-bsp once all the
#                 boards using unibuild are adjusted to use virtual package.
DEPEND="
	chromeos-base/chromeos-config-bsp
"

RDEPEND="${DEPEND}"
