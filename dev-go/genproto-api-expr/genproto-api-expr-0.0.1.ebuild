# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

# The dev-go/genproto* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="github.com/google/go-genproto:google.golang.org/genproto 848deb03c04d9a338463a46b71f28a63b81c461b"

CROS_GO_PACKAGES=(
	"google.golang.org/genproto/googleapis/api/expr/v1alpha1"
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
RESTRICT="binchecks"

DEPEND="
	dev-go/genproto-rpc
"
RDEPEND="${DEPEND}"
