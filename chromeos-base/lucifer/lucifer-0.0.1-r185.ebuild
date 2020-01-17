# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_WORKON_COMMIT="ca260b65cf580c7fa876426c8a2e2ae96aac6f17"
CROS_WORKON_TREE="d014c244441bfef10c055279b63a61cc5b2526b6"
CROS_WORKON_PROJECT="chromiumos/infra/lucifer"
CROS_WORKON_LOCALNAME="../../infra/lucifer"

CROS_GO_BINARIES=(
	"lucifer/cmd/lucifer"
)

inherit cros-workon cros-go

DESCRIPTION="Chromium OS testing infrastructure"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/infra/lucifer/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="
	dev-go/errors:=
	dev-go/gcp-bigquery:=
	dev-go/go-sys:=
	dev-go/luci-tsmon:=
	dev-go/opencensus:=
	dev-go/subcommands:=
	dev-go/xerrors:=
"
RDEPEND=""
