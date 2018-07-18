# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

# The dev-go/luci-* packages are all built from this repo.  They should
# be updated together.
CROS_GO_SOURCE="chromium.googlesource.com/infra/luci/luci-go:go.chromium.org/luci 77b23ce4c9189484e14035690f439c97f7629c2e"

CROS_GO_PACKAGES=(
	"go.chromium.org/luci/logdog/api/endpoints/coordinator/registration/v1"
	"go.chromium.org/luci/logdog/api/logpb"
	"go.chromium.org/luci/logdog/client/annotee"
	"go.chromium.org/luci/logdog/client/annotee/annotation"
	"go.chromium.org/luci/logdog/client/butler"
	"go.chromium.org/luci/logdog/client/butler/bundler"
	"go.chromium.org/luci/logdog/client/butler/output"
	"go.chromium.org/luci/logdog/client/butler/output/logdog"
	"go.chromium.org/luci/logdog/client/butler/output/pubsub"
	"go.chromium.org/luci/logdog/client/butler/streamserver"
	"go.chromium.org/luci/logdog/client/butlerproto"
	"go.chromium.org/luci/logdog/client/butlerlib/streamclient"
	"go.chromium.org/luci/logdog/client/butlerlib/streamproto"
	"go.chromium.org/luci/logdog/common/types"
	"go.chromium.org/luci/logdog/common/viewer"
)

inherit cros-go

DESCRIPTION="LUCI Go LogDog stream client library"
HOMEPAGE="https://chromium.googlesource.com/infra/luci/luci-go/"
SRC_URI="$(cros-go_src_uri)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""
# Tests require a lot of packages
RESTRICT="binchecks test strip"

DEPEND="
	dev-go/luci-common
	dev-go/luci-config
	dev-go/luci-grpc
	dev-go/protobuf
"
RDEPEND="${DEPEND}"
