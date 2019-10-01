# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="18236e5219b7a96f76273e601c5e118929467200"
CROS_WORKON_TREE=("beeedead63b0aaf468296d1d302d942cd2967327" "48cb279e4fb1a27b18512d2ae0e124905e7c2c87" "bad0b8adb253c220115f732b3c328e80b9f212f7" "1d2f9c776eee6863964479b6f1b1a272b4e81f26" "7b5048701281bd118d078b5993b44782afe35de4")
CROS_WORKON_PROJECT="apps/libapps"
CROS_WORKON_LOCALNAME="../third_party/libapps"
CROS_WORKON_SUBTREE="libdot hterm nassh ssh_client terminal"

inherit cros-workon

DESCRIPTION="The Chromium OS Shell extension (the HTML/JS rendering part)"
HOMEPAGE="https://chromium.googlesource.com/apps/libapps/+/master/nassh/doc/chromeos-crosh.md"
# These are kept in sync with libdot.py settings.
NPM_HASH="84259097b393ed263265e277bc3dcd102efb2c8f192be710bab12ed1cd1e7808"
SRC_URI="
	https://storage.googleapis.com/chromium-nodejs/10.15.3/3f578b6dec3fdddde88a9e889d9dd5d660c26db9
	https://storage.googleapis.com/chromeos-localmirror/secureshell/distfiles/node_modules-6aa8e3885b83f646e15bd56f9f53b97a481fe1907da55519fd789ca755d9eca5.tar.xz
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
