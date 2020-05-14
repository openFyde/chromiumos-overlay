# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f6e2fc4776a918e36334c59c2f94e189eb371897"
CROS_WORKON_TREE=("d61196ecf33c8694ea883c54a96e92ed4403962a" "0bd181c042492e8ce320d70b9542a2a5583b52ac" "81a5cbd8a810eef66b839e48eb80e7d78fe4b077" "edcab05c45bba6be21c5849c5bd537ebf522867e" "19d98b86be96fd9a5a79447b8e340565f4e4c691")
CROS_WORKON_PROJECT="apps/libapps"
CROS_WORKON_LOCALNAME="third_party/libapps"
CROS_WORKON_SUBTREE="libdot hterm nassh ssh_client terminal"

inherit cros-workon

DESCRIPTION="The Chromium OS Shell extension (the HTML/JS rendering part)"
HOMEPAGE="https://chromium.googlesource.com/apps/libapps/+/master/nassh/doc/chromeos-crosh.md"
# These are kept in sync with libdot.py settings.
NPM_HASHES=(
	# Current one.
	868c99605627748d698c967ee64dbc2f00e40846e9bf6a4737c223a90687ed45
	# Next one.
	bc482f2b229bd0797c104263dc60cb884a1c90f6e65f07050d0b94b165b3a255
)
SRC_URI="
	https://storage.googleapis.com/chromium-nodejs/12.14.1/4572d3801500bcbebafadf203056d6263c840cda
	$(printf 'https://storage.googleapis.com/chromeos-localmirror/secureshell/distfiles/node_modules-%s.tar.xz ' \
		"${NPM_HASHES[@]}")
"

# The archives above live on Google maintained sites.
RESTRICT="nomirror"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

RDEPEND="!<chromeos-base/common-assets-0.0.2"

e() {
	echo "$@"
	"$@" || die
}

src_compile() {
	export VCSID="${CROS_WORKON_COMMIT:-${PF}}"
	e ./nassh/bin/mkdist --crosh-only
}

src_install() {
	local dir="/usr/share/chromeos-assets/crosh_builtin"
	dodir "${dir}"
	unzip -d "${D}${dir}" nassh/dist/crosh.zip || die
}
