# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="268b01a49f02ab618abf8e9b3ea768652b2b8f01"
CROS_WORKON_TREE=("7687922af949e75ea822b42a75214eba343f9615" "23a3803d5e023e51f56fdfff48d0e9e55728c7dc" "d491781c3bae0eafe917a1d586361d3c982df226" "d0fd0457995ca107b7fee6d66f92fd50a7cc4143" "7c2a6ea15a09a2cc3cfec4ab90652b4a0b2d560e")
CROS_WORKON_PROJECT="apps/libapps"
CROS_WORKON_LOCALNAME="../third_party/libapps"
CROS_WORKON_SUBTREE="libdot hterm nassh ssh_client terminal"

inherit cros-workon

DESCRIPTION="The Chromium OS Shell extension (the HTML/JS rendering part)"
HOMEPAGE="https://chromium.googlesource.com/apps/libapps/+/master/nassh/doc/chromeos-crosh.md"
# These are kept in sync with libdot.py settings.
NPM_HASHES=(
	# Current one.
	84259097b393ed263265e277bc3dcd102efb2c8f192be710bab12ed1cd1e7808
	# Next one.
	868c99605627748d698c967ee64dbc2f00e40846e9bf6a4737c223a90687ed45
)
SRC_URI="
	https://storage.googleapis.com/chromium-nodejs/10.15.3/3f578b6dec3fdddde88a9e889d9dd5d660c26db9
	$(printf 'https://storage.googleapis.com/chromeos-localmirror/secureshell/distfiles/node_modules-%s.tar.xz ' \
		"${NPM_HASHES[@]}")
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
