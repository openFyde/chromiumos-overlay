# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# When the time comes to roll to a new version:
# 1. Download the new binary by cipd command manually
# 2. Replace the version in this script
# 3. Zip the file
# 4. Upload the zip as
# gs://chromeos-localmirror/distfiles/linux-amd64:${version}.zip
# 5. Set the ACL of the file to public-read
# 6. Update manifest of the package by ebuild manifest command.

# released-2020-06-06
TCLINT_VERSION="O4btRfV3d9-QpZcWagaH08KXzjfRkw848EswbM6ReFkC"
SRC_URI="cipd://chromiumos/infra/tclint/linux-amd64:${TCLINT_VERSION} -> ${P}.zip"

DESCRIPTION="Linter for Chrome OS test configuration data"
HOMEPAGE="https://chromium.googlesource.com/infra/infra/+/HEAD/go/src/infra/cros/cmd/tclint"
RESTRICT="mirror"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""

S="${WORKDIR}"

src_install() {
	dobin "${S}/tclint"
}
