# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f20efa45270eb93bd763e2967447e260d43cf54e"
CROS_WORKON_TREE=("0a5f4b84ddd9bf96fca34e3137fc3ee40f99f183" "e84060b634f4ff079f83db650790c13ca6a896e0" "f6c16ced18484d333a33ff86715d1dc1154fa2a7" "77ae5fe07f633a914ecfb9c4e2e4587ed3bf9d11" "cd4a1b0ea75caed81d3d789912588a3c5ff0dd51")
CROS_WORKON_PROJECT="apps/libapps"
CROS_WORKON_LOCALNAME="third_party/libapps"
CROS_WORKON_SUBTREE="libdot hterm nassh ssh_client terminal"

inherit cros-workon

DESCRIPTION="The Chromium OS Shell extension (the HTML/JS rendering part)"
HOMEPAGE="https://chromium.googlesource.com/apps/libapps/+/master/nassh/doc/chromeos-crosh.md"
# These are kept in sync with libdot.py settings.
FONTS_HASHES=(
	# Current one.
	d6dc5eaf459abd058cd3aef1e25963fde893f9d87f5f55f340431697ce4b3506
	# Next one.
	d6dc5eaf459abd058cd3aef1e25963fde893f9d87f5f55f340431697ce4b3506
)
NPM_HASHES=(
	# Current one.
	bc482f2b229bd0797c104263dc60cb884a1c90f6e65f07050d0b94b165b3a255
	# Next one.
	2cd2dd365999ae139b6b0fb62a5a09e2a7fb5ab1c0926cf1968a1dec9b74fea5
)
SRC_URI="
	https://storage.googleapis.com/chromium-nodejs/14.15.4/b2e40ddbac04d05baafbb007f203c6663c9d4ca9
	$(printf 'https://storage.googleapis.com/chromeos-localmirror/secureshell/distfiles/fonts-%s.tar.xz ' \
		"${FONTS_HASHES[@]}")
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
