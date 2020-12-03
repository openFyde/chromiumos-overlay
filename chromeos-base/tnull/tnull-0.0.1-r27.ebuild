# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="46a08bf1f6ddcfbb0b8a41fb11d905a2eb54e3e7"
CROS_WORKON_TREE="21f032a381e9a9947061b8e482fe1485675c269d"
CROS_WORKON_PROJECT="chromiumos/infra/tnull"
CROS_WORKON_LOCALNAME="../infra/tnull"

CROS_GO_BINARIES=(
	"tnull"
)

CROS_GO_VERSION="${PF}"

inherit cros-go cros-workon

DESCRIPTION="Remote Test Driver minimal/fake implementation"
HOMEPAGE="https://chromium.googlesource.com/${CROS_WORKON_PROJECT}"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/cros-config-api
	dev-go/genproto
	dev-go/grpc
	dev-go/maruel-subcommands
	dev-go/protobuf
"

src_configure() {
	$(cros-workon_get_build_dir)/generate_metadata.sh
}
