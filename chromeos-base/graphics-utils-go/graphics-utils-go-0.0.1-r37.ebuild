# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3892f09ec2f54d637da5d4fce0287ff8b0dc76c1"
CROS_WORKON_TREE="fd4fd9d48341ffc1ae4885d0cb5ef6a3cd00da4f"
CROS_WORKON_PROJECT="chromiumos/platform/graphics"
CROS_WORKON_LOCALNAME="platform/graphics"

INSTALL_DIR="/usr/local/graphics"

CROS_GO_BINARIES=(
	# Add more apps here.
	"sanity/cmd/pass:${INSTALL_DIR}/pass"
	"trace_profiling/cmd/analyze:${INSTALL_DIR}/analyze"
	"trace_profiling/cmd/merge:${INSTALL_DIR}/harvest"
	"trace_profiling/cmd/merge:${INSTALL_DIR}/merge"
	"trace_profiling/cmd/profile:${INSTALL_DIR}/profile"
	"trace_replay/cmd/trace_replay:${INSTALL_DIR}/trace_replay"
)

CROS_GO_TEST=(
	"sanity/cmd/pass"
	"trace_profiling/cmd/analyze"
	"trace_profiling/cmd/merge"
	"trace_profiling/cmd/profile"
	"trace_replay/cmd/trace_replay"
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

inherit cros-go cros-workon
SRC_URI="$(cros-go_src_uri)"

DESCRIPTION="Portable graphics utils written in go"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/graphics/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-go/crypto
	dev-go/fogleman-gg
	dev-go/go-image
	dev-go/gofpdf
	dev-go/golang-freetype
	dev-go/gonum-plot
	dev-go/readline
	dev-go/svgo
"

RDEPEND="${DEPEND}"

src_prepare() {
	# Disable cgo and PIE on building Tast binaries. See:
	# https://crbug.com/976196
	# https://github.com/golang/go/issues/30986#issuecomment-475626018
	export CGO_ENABLED=0
	export GOPIE=0

	default
}
