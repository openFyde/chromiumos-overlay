# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_WORKON_COMMIT="0f3928779237012c7d4ff36f0d2f93b3056d9941"
CROS_WORKON_TREE="d4249f0389cbe535385e36c21a4665227a19762d"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="lorgnette/hwtests"

CROS_GO_WORKSPACE="${S}/lorgnette/hwtests"

CROS_GO_TEST=(
	"chromiumos/scanning/hwtests"
	"chromiumos/scanning/utils"
)

CROS_GO_BINARIES=(
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
