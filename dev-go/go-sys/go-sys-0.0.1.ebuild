# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_GO_SOURCE="go.googlesource.com/sys:golang.org/x/sys 3a4b5fb9f71f5874b2374ae059bc0e0bcb52e145"

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
