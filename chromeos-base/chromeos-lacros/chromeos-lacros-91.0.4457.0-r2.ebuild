# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# No git repo for this so use empty-project.
CROS_WORKON_COMMIT="3a01873e59ec25ecb10d1b07ff9816e69f3bbfee"
CROS_WORKON_TREE="8ce164efd78fcb4a68e898d8c92c7579657a49b1"
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="platform/empty-project"

inherit cros-workon

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

# All runtime dependencies should already be part of
# chromeos-base/chromeos-chrome, the ones that aren't will be handled in
# crbug.com/1199441.
RDEPEND="chromeos-base/chromeos-chrome"
# Omit DEPEND as nothing is built in this ebuild.
DEPEND=""

if [[ ${PV} != 9999 ]]; then
	ORIG_GS_URI_PREFIX="gs://chrome-unsigned/desktop-5c0tCh"
	LACROS_SQUASHFS="${PN}-squash-${PV}"
	LACROS_METADATA="${PN}-metadata-${PV}"
	SRC_URI="
		${ORIG_GS_URI_PREFIX}/${LACROS_SQUASHFS}
		${ORIG_GS_URI_PREFIX}/${LACROS_METADATA}
	"
fi

src_install() {
	insinto /opt/google/lacros
	newins "${DISTDIR}/${LACROS_SQUASHFS}" lacros.squash
	newins "${DISTDIR}/${LACROS_METADATA}" metadata.json
}
