# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=6

CROS_GO_SOURCE="github.com/mdlayher/vsock 65587aa3274a83bbca6fcb90c96e84a3912b3201"

CROS_GO_PACKAGES=(
	"github.com/mdlayher/vsock"
)

inherit cros-go

DESCRIPTION="Package for using AF_VSOCK in Go"
HOMEPAGE="https://github.com/mdlayher/vsock"
SRC_URI="$(cros-go_src_uri)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

RESTRICT="binchecks strip"

DEPEND="dev-go/go-sys"
RDEPEND=""
