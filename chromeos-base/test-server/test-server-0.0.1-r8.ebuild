# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="1c3bc92c80b93dcebff0f0212e8b302facf0d502"
CROS_WORKON_TREE=("5bda4343569fa57f5e5a59ecf33300e4f8336d15" "287b690e38596cc858f1dbd566cbdecf4d1ceb39")
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_SUBTREE="lib test"

inherit cros-workon

# TODO(shapiroc): Rename package to test-services
DESCRIPTION="Collection of test services installed into the cros_sdk env"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/test"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND=""

RDEPEND="${DEPEND}"

