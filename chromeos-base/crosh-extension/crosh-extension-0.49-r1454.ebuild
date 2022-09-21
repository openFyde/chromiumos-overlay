# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="40c0dfeb7626430c46f2e30d97eee0ca2eb22d9a"
CROS_WORKON_TREE=("e4c65aecd0fb53c58ae695abec72cd2aa2159f44" "ed191010357b1fd03fc95e6877c33fb2a4953283" "cd004037dfc3d9682ad0ec596766f5db42c14e09" "a9df4994a676d0d2b6fffa187f2d5d95c97d3b01" "a7006cb624862e8ff6be4e3365a4ad2c38334f35" "b7f27758aa5c7444a35b826092c45c1f033d1636" "7f8c473985ae68b41c6a7c2c9a9225d612ee17bf")
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
	1783fbfd71787cd865079440ed18b70de1654ad551d4cdffa296f38a82314060
	# Next one.
	d60a04e2925cb416d2338f759e46a2776760f69c8a975681d5d91b5db49bd5b9
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
