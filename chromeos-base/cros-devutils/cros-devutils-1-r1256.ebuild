# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="35099049ef9ef0d26292c70fea3ad1c82a461d89"
CROS_WORKON_TREE="ca49addb78c5c9e5dd77b6f3befa4bec0f841922"
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
