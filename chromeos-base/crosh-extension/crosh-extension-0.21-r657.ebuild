# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="b6b83583d254831a7ebf0ddb76c30d13568885d8"
CROS_WORKON_TREE=("71a7fa0c2a0c2517b889f3a0d1ed751d3313edab" "54dea7d09ecf4a5f7d20ad79eda4e85c71d721ca" "5be20c5ab141a786e0523349a742a52b442c65b0" "971da7d0e3ace4246a2e78a2c739f467b9cf4f75" "8f48602783545d1cefa1de9306b85238fb0bfa58")
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
)
SRC_URI="
	https://storage.googleapis.com/chromium-nodejs/10.15.3/3f578b6dec3fdddde88a9e889d9dd5d660c26db9
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
