# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

CROS_GO_SOURCE="github.com/census-instrumentation/opencensus-go:go.opencensus.io v${PV}"

CROS_GO_PACKAGES=(
	"go.opencensus.io"
	"go.opencensus.io/exporter/stackdriver/propagation"
	"go.opencensus.io/internal"
	"go.opencensus.io/internal/tagencoding"
	"go.opencensus.io/metric/metricdata"
	"go.opencensus.io/metric/metricproducer"
	"go.opencensus.io/plugin/ocgrpc"
	"go.opencensus.io/plugin/ochttp"
	"go.opencensus.io/plugin/ochttp/propagation/b3"
	"go.opencensus.io/resource"
	"go.opencensus.io/stats"
	"go.opencensus.io/stats/internal"
	"go.opencensus.io/stats/view"
	"go.opencensus.io/tag"
	"go.opencensus.io/trace/..."
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="A stats collection and distributed tracing framework"
HOMEPAGE="http://opencensus.io/"
SRC_URI="$(cros-go_src_uri)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="
	dev-go/gapi-bundler
	dev-go/genproto
	dev-go/golang-groupcache
	dev-go/protobuf
	dev-go/protobuf-legacy-api
"
RDEPEND="${DEPEND}"
