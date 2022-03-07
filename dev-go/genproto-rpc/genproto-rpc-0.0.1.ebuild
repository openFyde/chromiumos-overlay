# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# The dev-go/genproto* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="github.com/google/go-genproto:google.golang.org/genproto 43724f9ea8cfe9ecde3dd00c5b763498f9840a03"

CROS_GO_PACKAGES=(
	"google.golang.org/genproto/googleapis/rpc/code"
	"google.golang.org/genproto/googleapis/rpc/errdetails"
	"google.golang.org/genproto/googleapis/rpc/status"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="Go generated proto packages"
HOMEPAGE="https://github.com/googleapis/googleapis/"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="dev-go/protobuf"
RDEPEND="
	${DEPEND}
"
