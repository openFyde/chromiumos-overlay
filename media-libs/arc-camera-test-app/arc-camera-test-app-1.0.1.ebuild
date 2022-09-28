# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Test app to exercise ARC camera usages"

SRC_URI="gs://chromeos-localmirror/distfiles/ArcCameraTest-${PV}.apk"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}"

src_install() {
	insinto /usr/libexec/tast/apks/local/cros
	newins "${DISTDIR}/ArcCameraTest-${PV}.apk" "ArcCameraTest.apk"
}
