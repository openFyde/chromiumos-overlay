# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

DESCRIPTION="Chrome OS Kernel virtual package"
HOMEPAGE="http://src.chromium.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="-kernel_next"

RDEPEND="
	kernel_next? ( sys-kernel/chromeos-kernel-next )
	!kernel_next? ( sys-kernel/chromeos-kernel )
"
