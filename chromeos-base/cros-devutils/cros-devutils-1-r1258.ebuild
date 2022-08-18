# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="31f31a91b4f66c04ea038a5684bcd8dd0faa263a"
CROS_WORKON_TREE="4dae4f17d30a5892fea79e517df78036bca130aa"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="host"

inherit cros-workon

DESCRIPTION="Development utilities for ChromiumOS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/host/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="app-portage/gentoolkit
	>=chromeos-base/devserver-0.0.2
	dev-util/shflags
	dev-util/toolchain-utils
	"
# These are all either bash / python scripts.  No actual builds DEPS.
DEPEND=""

src_compile() { :; }

src_install() {
	dobin host/cros_workon_make
}
