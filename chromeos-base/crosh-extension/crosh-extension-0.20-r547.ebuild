# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="3a44a44a60200650738f4b4a272cdec3592f789b"
CROS_WORKON_TREE=("73e921cc8e4eaddfb155c30bbbf8b3bce752b3eb" "95754168a3f42da3914410eb3b886479c67d75f4" "24745bcbd71728b1840bab441279f818c9a8ec66" "412e388981e2b162bce6b31b8c243dcc7f2c1b95" "99e41816d969cd857c8f1b771e9b0e8f0f3fc121")
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
