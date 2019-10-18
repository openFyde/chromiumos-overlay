# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="14fc00089102fc43e07b5ecf581efc12302ad9dd"
CROS_WORKON_TREE="ea84d2d2b15f3db04658fe14890dce770c68883f"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"

inherit cros-workon multilib

DESCRIPTION="Development utilities for ChromiumOS"
HOMEPAGE="http://www.chromium.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="test"

RDEPEND="app-portage/gentoolkit
	>=chromeos-base/devserver-0.0.2
	dev-lang/python
	dev-util/shflags
	dev-util/toolchain-utils
	sys-apps/flashmap
	"
# These are all either bash / python scripts.  No actual builds DEPS.
DEPEND=""

src_install() {
	local host_tools=(
		cros_workon_make
		netboot_firmware_settings.py
		strip_package
	)
	dobin "${host_tools[@]/#/host/}"

	# Repo and git bash completion.
	insinto /usr/share/bash-completion
	newins host/repo_bash_completion repo
	dosym /usr/share/bash-completion/repo /etc/bash_completion.d/repo
	dosym /usr/share/bash-completion/completions/git /etc/bash_completion.d/git
}
