# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_GO_SOURCE="github.com/mafredri/cdp 253ba5601ff3322f46391d41f052e107905fb5a4"

CROS_GO_PACKAGES=(
	"github.com/mafredri/cdp"
	"github.com/mafredri/cdp/devtool"
	"github.com/mafredri/cdp/internal/..."
	"github.com/mafredri/cdp/protocol/..."
	"github.com/mafredri/cdp/rpcc"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="Type-safe bindings for the Chrome Debugging Protocol written in Go"
HOMEPAGE="https://github.com/mafredri/cdp"
SRC_URI="$(cros-go_src_uri)"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="test"
RESTRICT="binchecks strip"

DEPEND="
	test? (
		dev-go/cmp
		dev-go/sync
	)"
RDEPEND="dev-go/websocket"
