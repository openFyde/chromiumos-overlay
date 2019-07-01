# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="069f2a92133ad5b96ec25ee8c150344666b7ebad"
CROS_WORKON_TREE=("3203fc5c38912e1d0625e33126a801b6ae1a0c59" "7c8209692ee0add5e5fe2f26fba75cf4877f1c9c" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk cros_component .gn"

PLATFORM_SUBDIR="cros_component"

inherit cros-workon platform

DESCRIPTION="Configurations for Chrome OS universial installer"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

src_compile() {
	true
}

src_install() {
	insinto /etc
	doins cros_component.config
}
