# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="9af2f47da78b1af33772bb99e6931e8375522520"
CROS_WORKON_TREE=("ec047c06a814504bb29729492cd9b863a3e44110" "eeeba3bed5e5cd26205a7dd832abaee52145d345" "c40f2808511e1ba61c23498f40e119fdf2842d08" "603ed596bd44f75d558cc7076477426a8f30217d" "074d60789636fc2ff893186f2d956af3ad7212a8")
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
