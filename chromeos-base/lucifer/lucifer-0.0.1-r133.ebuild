# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_WORKON_COMMIT="eda70aef216fb9c9da347e7b6f7ddcf82ac9902e"
CROS_WORKON_TREE="fa7de6044045375b9eebcb3910508313b2a7f3cb"
CROS_WORKON_PROJECT="chromiumos/infra/lucifer"
CROS_WORKON_LOCALNAME="../../infra/lucifer"

CROS_GO_BINARIES=(
	"lucifer/cmd/lucifer"
	"lucifer/cmd/skylab_swarming_worker"
)

inherit cros-workon cros-go

DESCRIPTION="Chromium OS testing infrastructure"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/infra/lucifer/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="
	dev-go/errors
	dev-go/gcp-bigquery
	dev-go/go-sys
	dev-go/luci-logdog-streamclient
	dev-go/luci-swarming
	dev-go/luci-tsmon
	dev-go/opencensus
	dev-go/subcommands
"
RDEPEND=""
