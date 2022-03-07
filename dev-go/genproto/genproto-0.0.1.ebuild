# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# The dev-go/genproto* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="github.com/google/go-genproto:google.golang.org/genproto 43724f9ea8cfe9ecde3dd00c5b763498f9840a03"

CROS_GO_PACKAGES=(
	"google.golang.org/genproto/googleapis/api"
	"google.golang.org/genproto/googleapis/api/annotations"
	"google.golang.org/genproto/googleapis/api/distribution"
	"google.golang.org/genproto/googleapis/api/label"
	"google.golang.org/genproto/googleapis/api/metric"
	"google.golang.org/genproto/googleapis/api/monitoredres"
	"google.golang.org/genproto/googleapis/devtools/cloudtrace/v2"
	"google.golang.org/genproto/googleapis/iam/v1"
	"google.golang.org/genproto/googleapis/longrunning"
	"google.golang.org/genproto/googleapis/monitoring/v3"
	"google.golang.org/genproto/googleapis/pubsub/v1"
	"google.golang.org/genproto/googleapis/storage/v2"
	"google.golang.org/genproto/googleapis/type/calendarperiod"
	"google.golang.org/genproto/googleapis/type/date"
	"google.golang.org/genproto/googleapis/type/expr"
	"google.golang.org/genproto/protobuf/field_mask"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

inherit cros-go

DESCRIPTION="Go generated proto packages"
HOMEPAGE="https://github.com/googleapis/googleapis/"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
RESTRICT="binchecks strip"

DEPEND="
	dev-go/genproto-rpc
	dev-go/grpc
"
RDEPEND="${DEPEND}"
