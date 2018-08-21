# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_WORKON_COMMIT="5eec51f99a351096d8cf2361d363fcc5c77a0cd1"
CROS_WORKON_TREE="a052f468a36978669d5e9a98c44b3213ca6bc296"
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
