# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9d54a0b24abba30bc99108c770d8cdae0947fa52"
CROS_WORKON_TREE=("c8e4301d10abb183fbcae5129cdfb4e39976794e" "62c970ef2bd2e7684fcf95bdfb74f34be8f6b39e" "4bb6852abc68b1d336ecb96b59feb1cd00b07dcf" "d0acc31ea3395f8ee93a30762441b4aaa5c1ab0d" "6b8af6a0c88be075c60fe9fa728f4f6f998fd1ac")
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
	2cd2dd365999ae139b6b0fb62a5a09e2a7fb5ab1c0926cf1968a1dec9b74fea5
	# Next one.
	16e0b36c0c3d448c7fd00d1db3ba27ff8477007fb4b0eae31ae25960aeae3fbc
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
