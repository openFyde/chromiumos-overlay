# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_WORKON_COMMIT="7a088d53621117880bc35bfb7164361c5cf225ad"
CROS_WORKON_TREE="72772217565c019f82af07fbe69d3b893043c307"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="lorgnette/hwtests"

CROS_GO_WORKSPACE="${S}/lorgnette/hwtests"

CROS_GO_TEST=(
	"chromiumos/scanning/hwtests"
	"chromiumos/scanning/utils"
)

CROS_GO_BINARIES=(
	"chromiumos/scanning/scripts/test_scan_source"
	"chromiumos/scanning/scripts/test_scanner_capabilities"
)

inherit cros-go cros-workon

DESCRIPTION="Works with Chromebook test suite for scanners"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/lorgnette/hwtests"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"

DEPEND="
	dev-go/cmp
"
RDEPEND="
	chromeos-base/lorgnette_cli
"
