# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_GO_SOURCE="go.googlesource.com/sys:golang.org/x/sys a646d33e2ee3172a661fc09bca23bb4889a41bc8"

CROS_GO_PACKAGES=(
	"golang.org/x/sys/unix"
)

CROS_GO_TEST=(
	"golang.org/x/sys/unix"
)

inherit cros-go

DESCRIPTION="Go packages for low-level interaction with the operating system"
HOMEPAGE="https://golang.org/x/sys"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""
