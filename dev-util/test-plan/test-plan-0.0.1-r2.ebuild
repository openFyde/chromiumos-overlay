# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4275bea1bb351525e0453739dc0fdd8bbab3af5b"
CROS_WORKON_TREE="b54039c096fb595a7d751116bcdec58276b50fd3"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/plan"

inherit cros-go cros-workon

DESCRIPTION="A tool to generate ChromeOS CoverageRule protos from SourceTestPlan protos."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/plan"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_BINARIES=(
	"chromiumos/test/plan/cmd"
)

CROS_GO_TEST=(
	"chromiumos/test/plan/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	chromeos-base/cros-config-api
	dev-go/luci-go-common
	dev-go/maruel-subcommands
	dev-go/protobuf
"
RDEPEND="${DEPEND}"
