# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_GO_SOURCE="chromium.googlesource.com/chromiumos/infra/proto:go.chromium.org/chromiumos/infra/proto 449bf06264884fee06f01772819d01f760f5ee5e"

CROS_GO_PACKAGES=(
	"go.chromium.org/chromiumos/infra/proto/go/chromite/api"
	"go.chromium.org/chromiumos/infra/proto/go/chromite/observability"
	"go.chromium.org/chromiumos/infra/proto/go/chromiumos"
	"go.chromium.org/chromiumos/infra/proto/go/device"
	"go.chromium.org/chromiumos/infra/proto/go/lab"
	"go.chromium.org/chromiumos/infra/proto/go/manufacturing"
	"go.chromium.org/chromiumos/infra/proto/go/testplans"
	"go.chromium.org/chromiumos/infra/proto/go/test_platform"
	"go.chromium.org/chromiumos/infra/proto/go/test_platform/execution"
)

inherit cros-go

DESCRIPTION="Go bindings for ChromiumOS infra protocol buffers."
HOMEPAGE="chromium.googlesource.com/chromiumos/infra/proto"
SRC_URI="$(cros-go_src_uri)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/cros-config-api
	dev-go/genproto
	dev-go/go-sys
	dev-go/grpc
	dev-go/net
	dev-go/protobuf
	dev-go/protobuf-legacy-api
	dev-go/text
"
RDEPEND="${DEPEND}"
