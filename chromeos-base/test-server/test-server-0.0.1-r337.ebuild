# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="078d022fb8ecaafb990232c8702839a72e21ac0a"
CROS_WORKON_TREE="336cfd53eb17f81d86c936dde205c0d84373ed2b"
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
