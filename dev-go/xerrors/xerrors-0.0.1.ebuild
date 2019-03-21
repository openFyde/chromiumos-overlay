# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_GO_SOURCE="github.com/golang/xerrors:golang.org/x/xerrors d61658bd2e18010be0e21349cc92b1b706e35146"

CROS_GO_PACKAGES=(
	"golang.org/x/xerrors"
	"golang.org/x/xerrors/internal"
)

inherit cros-go

DESCRIPTION="This package supports transitioning to the Go 2 proposal for error values."
HOMEPAGE="https://github.com/golang/xerrors"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""
