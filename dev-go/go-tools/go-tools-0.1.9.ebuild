# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_GO_SOURCE="go.googlesource.com/tools:golang.org/x/tools v${PV}"

CROS_GO_PACKAGES=(
	"golang.org/x/tools/go/analysis"
	"golang.org/x/tools/go/analysis/analysistest"
	"golang.org/x/tools/go/analysis/internal/analysisflags"
	"golang.org/x/tools/go/analysis/internal/checker"
	"golang.org/x/tools/go/analysis/passes/inspect"
	"golang.org/x/tools/go/ast/astutil"
	"golang.org/x/tools/go/ast/inspector"
	"golang.org/x/tools/go/buildutil"
	"golang.org/x/tools/go/gcexportdata"
	"golang.org/x/tools/go/internal/cgo"
	"golang.org/x/tools/go/internal/gcimporter"
	"golang.org/x/tools/go/internal/packagesdriver"
	"golang.org/x/tools/go/loader"
	"golang.org/x/tools/go/packages"
	"golang.org/x/tools/go/types/objectpath"
	"golang.org/x/tools/go/types/typeutil"
	"golang.org/x/tools/internal/analysisinternal"
	"golang.org/x/tools/internal/event"
	"golang.org/x/tools/internal/event/core"
	"golang.org/x/tools/internal/event/keys"
	"golang.org/x/tools/internal/event/label"
	"golang.org/x/tools/internal/fastwalk"
	"golang.org/x/tools/internal/gocommand"
	"golang.org/x/tools/internal/gopathwalk"
	"golang.org/x/tools/internal/lsp/fuzzy"
	"golang.org/x/tools/internal/lsp/diff/..."
	"golang.org/x/tools/internal/packagesinternal"
	"golang.org/x/tools/internal/span"
	"golang.org/x/tools/internal/testenv"
	"golang.org/x/tools/internal/typesinternal"
	"golang.org/x/tools/internal/typeparams"
	"golang.org/x/tools/imports"
	"golang.org/x/tools/internal/imports"
	"golang.org/x/tools/txtar"
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

DEPEND="
	dev-go/mod
	dev-go/net
	dev-go/sync
	dev-go/xerrors
	dev-go/text
	dev-go/goldmark
"
RDEPEND="${DEPEND}"
