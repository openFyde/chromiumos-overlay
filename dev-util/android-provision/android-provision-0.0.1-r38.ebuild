# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e5bfabfa031eef6a78865a68a271490a4255c7cc"
CROS_WORKON_TREE=("87ef2de342a4477da72fa36a5f9bdffe39d2cf12" "3efc83cf3e430b00e6246bfe693d7bc14672a481")
CROS_GO_SOURCE=(
	"github.com/jtolio/gls:github.com/jtolds/gls v4.20.0"
	"github.com/smartystreets/assertions v1.13.0"
	"github.com/smartystreets/goconvey v1.7.2"
)

CROS_GO_PACKAGES=(
	"github.com/jtolds/gls"
	"github.com/smartystreets/assertions"
	"github.com/smartystreets/assertions/internal/go-diff/diffmatchpatch"
	"github.com/smartystreets/assertions/internal/go-render/render"
	"github.com/smartystreets/assertions/internal/oglematchers"
	"github.com/smartystreets/goconvey/convey"
	"github.com/smartystreets/goconvey/convey/gotest"
	"github.com/smartystreets/goconvey/convey/reporting"
)

CROS_GO_WORKSPACE=(
	"${S}"
)

CROS_GO_BINARIES=(
	"chromiumos/test/provision/v2/android-provision"
)

CROS_GO_TEST=(
	"chromiumos/test/provision/v2/android-provision/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/provision src/chromiumos/test/util"

inherit cros-go cros-workon

DESCRIPTION="Android provision server implementation for installing packages on a test device"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/provision/v2/android-provision"
SRC_URI="$(cros-go_src_uri)"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-util/lro-server
	dev-util/lroold-server
	dev-go/gcp-storage
	dev-go/genproto
	dev-go/luci-go-cipd
	dev-go/mock
	dev-go/protobuf
	dev-go/protobuf-legacy-api
	chromeos-base/cros-config-api
"
RDEPEND="${DEPEND}"

src_prepare() {
	# CGO_ENABLED=0 will make the executable statically linked.
	export CGO_ENABLED=0
	# Unpack the Go source tarballs.
	cros-go_src_unpack

	default
}
