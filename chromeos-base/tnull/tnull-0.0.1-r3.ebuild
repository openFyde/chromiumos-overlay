# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="933a6f18142d535a5a70eb51167500cc32198453"
CROS_WORKON_TREE="0a12138e5e5f2f7e6f9dada43851179607571f94"
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
	chromeos-base/cros-config-api:=
	dev-go/luci-common:=
"
