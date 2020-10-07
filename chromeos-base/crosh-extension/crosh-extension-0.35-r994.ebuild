# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d5d04b587a0f9925ca698811253cf90463b790d4"
CROS_WORKON_TREE=("558093ccebee184fc0d62306eae1ca422d1c67af" "30b92ff0eca89b62cf8eac95fd196ace6ad9a599" "2ccd87e7739c882ebb9884c064fb4e1109ab1fb5" "421b23abd32f2705d651f260fe6de9e8d3d7cb32" "ae9c738514d8b885ed162710d41538dd1fe43e73")
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
	https://storage.googleapis.com/chromium-nodejs/12.14.1/4572d3801500bcbebafadf203056d6263c840cda
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
