# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="17c227b8e23c93aa5a8170a11a8366cdcdc8f7f7"
CROS_WORKON_TREE="ccc21c2b7729c0d6598121baa69b1b567bced589"
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
