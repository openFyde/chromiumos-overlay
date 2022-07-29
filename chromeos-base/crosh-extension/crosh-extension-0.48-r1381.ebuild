# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9dc49ca44a9b658e33b48216860c6720626360f2"
CROS_WORKON_TREE=("2966aed9e8597bf42b8fcda849405bdb53c4b5f9" "0ea613aa2c5ab7bbe06182b08befb06ed715571d" "8d34527189dac10484eb4dc2faed93c95718e47c" "f2813f639f3202f292b4e1a4474ad9521c40b566" "80da54abeb2696db146be860ea7de7b887c7c75c" "818feadd37d21ca7c3a3c3bf100ccfe0e63f1c8c" "a772d103d049d686056f6c8508785dcd91bdc484")
CROS_WORKON_PROJECT="apps/libapps"
CROS_WORKON_LOCALNAME="third_party/libapps"
CROS_WORKON_SUBTREE="libdot hterm nassh ssh_client terminal wasi-js-bindings wassh"

inherit cros-workon

DESCRIPTION="The Chromium OS Shell extension (the HTML/JS rendering part)"
HOMEPAGE="https://chromium.googlesource.com/apps/libapps/+/master/nassh/doc/chromeos-crosh.md"
# These are kept in sync with libdot.py settings.
FONTS_HASHES=(
	# Current one.
	d6dc5eaf459abd058cd3aef1e25963fde893f9d87f5f55f340431697ce4b3506
	# Next one.
)
NODE_HASHES=(
	# Current one.
	14.15.4/b2e40ddbac04d05baafbb007f203c6663c9d4ca9
	# Next one.
	16.13.0/ab9544e24e752d3d17f335fb7b2055062e582d11
)
NPM_HASHES=(
	# Current one.
	7539e02265e046755ad0fffa36018f915c4feeb2c87f21346ded68a857f38153
	# Next one.
	70ab4f912a599b4d3e01dc6548243857a812d0b858e4d2ea6bdfd036357ee0c9
)
PLUGIN_VERSIONS=(
	# Current one.
	0.46
	# Next one.
	0.48
)
SRC_URI="
	$(printf 'https://storage.googleapis.com/chromium-nodejs/%s ' "${NODE_HASHES[@]}")
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
