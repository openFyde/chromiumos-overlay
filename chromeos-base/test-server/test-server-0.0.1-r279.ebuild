# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3eeac1dbf6eb8143da66540d1847ee50a9f86085"
CROS_WORKON_TREE="fe47ee2bb28031418f8dac1f0de29727b3a52949"
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
