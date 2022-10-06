# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a047571786573103201bbe9e6c1c1a1c38b6014a"
CROS_WORKON_TREE=("3fd7226c045778c8eb039a499cffc2837431ae8e" "2dca94511408ab164d2ee5405e80fdd7bd92d7cc" "72e616c0d55f9a0fbd58a099df133f46c11f18ed" "ba313df3b3eeb1c08a56e6490a84c394fb52da1c" "79eba4f74dc0facf0aa56dace40dccadcd031dca" "9688c89423747fb5cc3417a991738320b8de7521" "dba9f4b1a9b1ff06528e2858dc844d7ee5dfcf95")
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
	d60a04e2925cb416d2338f759e46a2776760f69c8a975681d5d91b5db49bd5b9
	# Next one.
	58a84c94cbbc35f0f76d0d4195cee8a9a6607fc8a202f38e0b7ceff0c81f408d
)
PLUGIN_VERSIONS=(
	# Current one.
	0.49
	# Next one.
	0.50
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
