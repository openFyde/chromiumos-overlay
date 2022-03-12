# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_GO_SOURCE="chromium.googlesource.com/infra/luci/luci-go:go.chromium.org/luci fbf085364d0e2db2aa35e78f526ca0d7468201a8"

CROS_GO_PACKAGES=(
	"go.chromium.org/luci/buildbucket/proto"
	"go.chromium.org/luci/common/clock"
	"go.chromium.org/luci/common/data/cmpbin"
	"go.chromium.org/luci/common/data/stringset"
	"go.chromium.org/luci/common/data/strpair"
	"go.chromium.org/luci/common/data/text/indented"
	"go.chromium.org/luci/common/errors"
	"go.chromium.org/luci/common/flag"
	"go.chromium.org/luci/common/iotools"
	"go.chromium.org/luci/common/logging"
	"go.chromium.org/luci/common/proto"
	"go.chromium.org/luci/common/retry"
	"go.chromium.org/luci/common/retry/transient"
	"go.chromium.org/luci/common/runtime/goroutine"
	"go.chromium.org/luci/common/runtime/paniccatcher"
	"go.chromium.org/luci/common/sync/parallel"
	"go.chromium.org/luci/gae/internal/zstd"
	"go.chromium.org/luci/gae/service/blobstore"
	"go.chromium.org/luci/gae/service/datastore"
	"go.chromium.org/luci/gae/service/datastore/internal/protos/datastore"
	"go.chromium.org/luci/gae/service/info"
	"go.chromium.org/luci/grpc/discovery"
	"go.chromium.org/luci/grpc/grpcutil"
	"go.chromium.org/luci/grpc/prpc"
	"go.chromium.org/luci/resultdb/proto/v1"
	"go.chromium.org/luci/server/router"
	"go.chromium.org/luci/starlark/interpreter"
	"go.chromium.org/luci/starlark/starlarkproto"
	"go.chromium.org/luci/starlark/typed"
	"go.chromium.org/luci/swarming/proto/api"
)

inherit cros-go

DESCRIPTION="LUCI-related packages and other common utility packages."
HOMEPAGE="https://chromium.googlesource.com/infra/luci/luci-go"
SRC_URI="$(cros-go_src_uri)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-go/appengine
	dev-go/gapi-googleapi
	dev-go/grpc
	dev-go/httprouter
	dev-go/klauspost-compress
	dev-go/protobuf
	dev-go/protobuf-legacy-api
	dev-go/starlark-go
	dev-go/txtpbfmt
	dev-go/yaml:0
"
RDEPEND="${DEPEND}"
