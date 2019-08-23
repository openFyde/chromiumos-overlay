# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="8760c1e4491975fb796b68d00ed6c30db7073723"
CROS_WORKON_TREE=("2e0e02c3186e60245f155cd5f360aed336e7dc80" "182a42ca1198e7fedf589d0af6907786117e1786" "e16daab99f8f4a218f5eaead0f11b5ddfefd3c5a" "7e40162eae8513cca1d43035a7ec0603910e5703" "836885283d6586f1133b9320e2ce0cafc86f57ee")
CROS_WORKON_PROJECT="apps/libapps"
CROS_WORKON_LOCALNAME="../third_party/libapps"
CROS_WORKON_SUBTREE="libdot hterm nassh ssh_client terminal"

inherit cros-workon

DESCRIPTION="The Chromium OS Shell extension (the HTML/JS rendering part)"
HOMEPAGE="https://chromium.googlesource.com/apps/libapps/+/master/nassh/doc/chromeos-crosh.md"
# These are kept in sync with libdot.py settings.
NPM_HASH="6aa8e3885b83f646e15bd56f9f53b97a481fe1907da55519fd789ca755d9eca5"
SRC_URI="
	https://storage.googleapis.com/chromium-nodejs/10.15.3/3f578b6dec3fdddde88a9e889d9dd5d660c26db9
	https://storage.googleapis.com/chromeos-localmirror/secureshell/distfiles/node_modules-${NPM_HASH}.tar.xz
"

# The archives above live on Google maintained sites.
RESTRICT="nomirror"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="!<chromeos-base/common-assets-0.0.2"

e() {
	echo "$@"
	"$@" || die
}

src_compile() {
	export VCSID="${CROS_WORKON_COMMIT:-${PF}}"
	e ./nassh/bin/mkcrosh.sh
}

src_install() {
	local dir="/usr/share/chromeos-assets/crosh_builtin"
	dodir "${dir}"
	unzip -d "${D}${dir}" nassh/dist/zip/crosh*.zip || die
}
