# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="bbe542594c536c6d52f25694552ca2db29639fcd"
CROS_WORKON_TREE="0aaebafdc2226b9c10fcfcf4e78146d6f1d33b67"
CROS_WORKON_PROJECT="chromiumos/platform/chameleon"

inherit cros-workon cros-sanitizers

DESCRIPTION="Chameleon bundle for Autotest lab deployment"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/chameleon/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="dev-lang/python"
DEPEND="${RDEPEND}"

src_configure() {
	sanitizers-setup-env
	default
}

src_install() {
	local base_dir="/usr/share/chameleon-bundle"
	insinto "${base_dir}"
	newins dist/chameleond-*.tar.gz chameleond-${PVR}.tar.gz
}

# TODO(b/233251906): Update and uncomment src_test() once we have unit tests in this package.
#src_test(){
#}
