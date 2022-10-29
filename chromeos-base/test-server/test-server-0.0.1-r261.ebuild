# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="aa88257e8a04319b3a51a3a3eb261982d97d04a9"
CROS_WORKON_TREE="b98ce427377ac2c840546305a813251990618e21"
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
