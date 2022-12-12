# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="d6f85940fb361e2d126fc0085827c3eb03de2cc6"
CROS_WORKON_TREE="0889ddb4927b582060202be9e8f10f2122668a0e"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_SUBTREE="src"

inherit cros-workon

# TODO(shapiroc): Delete after SDK migrated test-services package
DESCRIPTION="Obsolete (to remove)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
