# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("ef130564ca35f8531462dbf5fb10c6f912e75636" "efb83b2a535cd5315e30ade2be25db3dd25d2c99")
CROS_WORKON_TREE=("581baa9d190fbeb976bef4c0c93e200dc56ad373" "c59a77cc9042a82971c12f086931b81bb04604e8")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/tast-tests"
	"chromiumos/platform/tast"
)
CROS_WORKON_LOCALNAME=(
	"tast-tests"
	"tast"
)
CROS_WORKON_DESTDIR=(
	"${S}"
	"${S}/tast-base"
)
# TODO(derat): Delete this hack after https://crbug.com/812032 is addressed.
CROS_GO_WORKSPACE="${S}:${S}/tast-base"

CROS_GO_TEST=(
	# Test support packages that live above remote/bundles/.
	"chromiumos/tast/remote/..."
)

inherit cros-workon tast-bundle

DESCRIPTION="Bundle of remote integration tests for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
