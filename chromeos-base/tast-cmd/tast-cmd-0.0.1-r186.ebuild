# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="d895d8e44170db537ed3f44f74f6f56dff793a19"
CROS_WORKON_TREE="c652a669e783c6019c95a0c6686fb5a4f084ba0b"
CROS_WORKON_PROJECT="chromiumos/platform/tast"
CROS_WORKON_LOCALNAME="tast"

CROS_GO_BINARIES=(
	"chromiumos/cmd/remote_test_runner"
	"chromiumos/cmd/tast"
)

CROS_GO_VERSION="${PF}"

CROS_GO_TEST=(
	"chromiumos/cmd/tast/..."
	# Also test common code.
	"chromiumos/tast/..."
)
CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

inherit cros-go cros-workon

DESCRIPTION="Host executables for running integration tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-go/crypto
	dev-go/subcommands
	dev-go/yaml
"
RDEPEND="
	app-arch/tar
	app-arch/xz-utils
	chromeos-base/google-breakpad
	net-misc/gsutil
	!chromeos-base/tast-common
"
