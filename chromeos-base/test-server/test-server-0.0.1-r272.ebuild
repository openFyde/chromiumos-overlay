# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="a5a4802de0459365143bb4fe5f51d15fabac9fd6"
CROS_WORKON_TREE="51b6068d4c1ac652d537c8f70f00832177e59343"
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
