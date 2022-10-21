# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="0f8dbccb1df6ad2633a45ab8e8bd01624c13103c"
CROS_WORKON_TREE="851777a3ee184ed6804ce7c47980d545dd0b092b"
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
