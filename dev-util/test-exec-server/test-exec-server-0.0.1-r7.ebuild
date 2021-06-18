# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="60e1bee9e48b86d8969e644e4f12dc9b166e7127"
CROS_WORKON_TREE="01dd9e78911fb46347e38d4376c0411e95d5d073"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/execution"

inherit cros-go cros-workon

DESCRIPTION="Test execution server for running tests and capturing results"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/execution"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}"
)

CROS_GO_BINARIES=(
	"chromiumos/test/execution/cmd/testexecserver"
)

CROS_GO_TEST=(
	"chromiumos/test/execution/cmd/testexecserver/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	chromeos-base/tast-cmd:=
	chromeos-base/tast-proto
	dev-util/lro-server
"
RDEPEND="${DEPEND}"
