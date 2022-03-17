# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="847a2984ecbf4c174cd5ae1a622dc507e7f0b19d"
CROS_WORKON_TREE=("56d9d8c7985c3b8f3004b1e4f228ed8c10c0a451" "7f3e5fc773241b39ba2871e5f8137afc531fe999" "ecc84b54a588b3f8a52bed6cf0e07097789a9986" "0968e97335ca5f3780e0931cd0b7e446bf5234ae" "24723b2ad48b6ed22ac68ca8ff651f6ca8ebbd06")
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
PLUGIN_VERSIONS=(
	# Current one.
	0.41
	# Next one.
	0.42
)
SRC_URI="
	https://storage.googleapis.com/chromium-nodejs/14.15.4/b2e40ddbac04d05baafbb007f203c6663c9d4ca9
	$(printf 'https://storage.googleapis.com/chromeos-localmirror/secureshell/distfiles/fonts-%s.tar.xz ' \
		"${FONTS_HASHES[@]}")
	$(printf 'https://storage.googleapis.com/chromeos-localmirror/secureshell/distfiles/node_modules-%s.tar.xz ' \
		"${NPM_HASHES[@]}")
	$(printf 'https://storage.googleapis.com/chromeos-localmirror/secureshell/releases/%s.tar.xz ' \
		"${PLUGIN_VERSIONS[@]}")
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
	local pnacl="${D}${dir}/plugin/pnacl"
	if ! use arm ; then
		rm "${pnacl}/ssh_client_nl_arm.nexe"* || die
	fi
	if ! use x86 ; then
		rm "${pnacl}/ssh_client_nl_x86_32.nexe"* || die
	fi
	if ! use amd64 ; then
		rm "${pnacl}/ssh_client_nl_x86_64.nexe"* || die
	fi
}
