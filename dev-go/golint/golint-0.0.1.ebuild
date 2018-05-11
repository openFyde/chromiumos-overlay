# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_GO_SOURCE="github.com/golang/lint c5fb716d6688a859aae56d26d3e6070808df29f7"

CROS_GO_BINARIES=(
	"github.com/golang/lint/golint"
)

inherit cros-go

DESCRIPTION="A linter for Go source code"
HOMEPAGE="https://github.com/golang/lint"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="dev-go/go-tools"
RDEPEND=""
