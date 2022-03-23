# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# The dev-go/gapi* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="github.com/google/google-api-go-client:google.golang.org/api ccca5aa6d9d9aba8ad11c879ccea89c94663ea39"

CROS_GO_PACKAGES=(
	"google.golang.org/api/internal"
	"google.golang.org/api/internal/gensupport"
	"google.golang.org/api/internal/impersonate"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="Auto-generated Google APIs for Go"
HOMEPAGE="https://github.com/google/google-api-go-client"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="
	dev-go/cmp
	dev-go/gax:1
	dev-go/grpc
	dev-go/oauth2
"
RDEPEND="${DEPEND}"
