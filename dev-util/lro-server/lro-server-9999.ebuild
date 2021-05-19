# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="lib"

inherit cros-go cros-workon

DESCRIPTION="Common golang library to support google.longrunning.operations server impls"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/lib/src/chromiumos/lro"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}/lib"
)

CROS_GO_PACKAGES=(
	"chromiumos/lro/..."
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="chromeos-base/cros-config-api"

RDEPEND=""
