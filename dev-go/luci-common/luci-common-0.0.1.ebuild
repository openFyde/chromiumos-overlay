# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# The dev-go/luci-* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="chromium.googlesource.com/infra/luci/luci-go:go.chromium.org/luci 77b23ce4c9189484e14035690f439c97f7629c2e"

CROS_GO_PACKAGES=(
	"go.chromium.org/luci/common/clock"
	"go.chromium.org/luci/common/clock/clockflag"
	"go.chromium.org/luci/common/data/chunkstream"
	"go.chromium.org/luci/common/data/rand/cryptorand"
	"go.chromium.org/luci/common/data/rand/mathrand"
	"go.chromium.org/luci/common/data/recordio"
	"go.chromium.org/luci/common/data/stringset"
	"go.chromium.org/luci/common/data/text/indented"
	"go.chromium.org/luci/common/errors"
	"go.chromium.org/luci/common/flag/flagenum"
	"go.chromium.org/luci/common/flag/stringmapflag"
	"go.chromium.org/luci/common/gcloud/googleoauth"
	"go.chromium.org/luci/common/gcloud/iam"
	"go.chromium.org/luci/common/gcloud/pubsub"
	"go.chromium.org/luci/common/iotools"
	"go.chromium.org/luci/common/lhttp"
	"go.chromium.org/luci/common/logging"
	"go.chromium.org/luci/common/logging/gologger"
	"go.chromium.org/luci/common/proto/git"
	"go.chromium.org/luci/common/proto/google"
	"go.chromium.org/luci/common/proto/milo"
	"go.chromium.org/luci/common/runtime/goroutine"
	"go.chromium.org/luci/common/runtime/paniccatcher"
	"go.chromium.org/luci/common/retry"
	"go.chromium.org/luci/common/retry/transient"
	"go.chromium.org/luci/common/sync/cancelcond"
	"go.chromium.org/luci/common/sync/parallel"
	"go.chromium.org/luci/common/system/environ"
	"go.chromium.org/luci/common/system/terminal"
	"go.chromium.org/luci/lucictx"
)

inherit cros-go

DESCRIPTION="LUCI Go common library"
HOMEPAGE="https://chromium.googlesource.com/infra/luci/luci-go/"
SRC_URI="$(cros-go_src_uri)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
# Tests import "github.com/smartystreets/goconvey/convey", which we don't have.
RESTRICT="binchecks test strip"

DEPEND="
	dev-go/crypto
	dev-go/gapi-googleapi
	dev-go/gcp-pubsub
	dev-go/net
	dev-go/oauth2
	dev-go/op-logging
	dev-go/protobuf
"
RDEPEND="${DEPEND}"
