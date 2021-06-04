# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b53ded5c4b7edc9ae3fe08b7658346ce9231a1ac"
CROS_WORKON_TREE="7366afc16e3cff0f37422264ff07d9ed39eec76e"
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
	dev-util/lro-server
"
RDEPEND="${DEPEND}"
