# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_WORKON_COMMIT="d2e0d5f46d2ccfd124be325e16e3f767daf68470"
CROS_WORKON_TREE="9fcbe7542c1fdb3babe2571edb831a588043f07d"
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
