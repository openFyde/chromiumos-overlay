# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_GO_SOURCE="github.com/catapult-project/catapult 35457f076227dce062ece5b51f3655223af1788f"

CROS_GO_BINARIES=(
	"github.com/catapult-project/catapult/web_page_replay_go/src/wpr.go"
)

CROS_GO_TEST=(
	"github.com/catapult-project/catapult/web_page_replay_go/src/webpagereplay"
)

inherit cros-go
SRC_URI="$(cros-go_src_uri)"

DESCRIPTION="Web Page Replay (for testing)"
HOMEPAGE="https://github.com/catapult-project/catapult/tree/master/web_page_replay_go"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-go/cli"
