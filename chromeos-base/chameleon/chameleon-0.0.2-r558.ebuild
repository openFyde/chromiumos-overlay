# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="c7f107117a421dbdb83c31b3e3843636d1ba3884"
CROS_WORKON_TREE="fa02eb143c561e9d13bbeabc03efe5052b2f6cc7"
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
