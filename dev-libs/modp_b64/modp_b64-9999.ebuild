# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-constants

CROS_WORKON_BLACKLIST=1
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_LOCALNAME="modp_b64"
CROS_WORKON_PROJECT="platform/external/modp_b64"
CROS_WORKON_REPO="${CROS_GIT_AOSP_URL}"

inherit cros-workon cros-common.mk

DESCRIPTION="Base64 encoder/decoder library."
HOMEPAGE="https://github.com/client9/stringencoders"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~*"
IUSE=""

src_install() {
	newlib.a "${OUT}"/libmodpb64.pie.a libmodp_b64.a

	insinto /usr/include
	doins -r modp_b64
}
