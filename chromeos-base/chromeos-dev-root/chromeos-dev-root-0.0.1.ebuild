# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Install packages that must live in the rootfs in dev images."
HOMEPAGE="http://www.chromium.org/"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
LICENSE="BSD-Google"
SLOT="0"

RDEPEND="
	chromeos-base/openssh-server-init
"