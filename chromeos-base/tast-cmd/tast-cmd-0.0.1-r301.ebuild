# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="db46c0cecae55f1af1b5224f7f687f0e9406b45e"
CROS_WORKON_TREE="567b33217150fd83b2b8fb928df82af948722972"
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
	dev-go/cmp
	dev-go/crypto
	dev-go/golint
	dev-go/gopsutil
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
