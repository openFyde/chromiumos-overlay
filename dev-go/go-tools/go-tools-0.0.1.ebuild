# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# pick go-tools at the current head of release-branch.go1.13
CROS_GO_SOURCE="go.googlesource.com/tools:golang.org/x/tools 65e3620a7ae7ac25e8494a60f0e5ef4e4fba03b3"

CROS_GO_PACKAGES=(
	"golang.org/x/tools/go/ast/astutil"
	"golang.org/x/tools/go/gcexportdata"
	"golang.org/x/tools/go/internal/gcimporter"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

CROS_GO_BINARIES=(
	"golang.org/x/tools/cmd/godoc"
	"golang.org/x/tools/cmd/goimports"
	"golang.org/x/tools/cmd/guru:goguru"
	"golang.org/x/tools/cmd/stringer"
)

inherit cros-go

DESCRIPTION="Packages and tools that support the Go programming language"
HOMEPAGE="https://golang.org/x/tools"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="dev-go/net"
RDEPEND=""
