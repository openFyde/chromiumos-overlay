# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="9cdc498c84ef0a096ed58f833f01c0cee1f7ce46"
CROS_WORKON_TREE="27b2f8dd0ff0d4a044e57b7b807ca16249d3ebe6"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"
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
	dev-lang/python
	dev-util/shflags
	dev-util/toolchain-utils
	sys-apps/flashmap
	"
# These are all either bash / python scripts.  No actual builds DEPS.
DEPEND=""

src_compile() { :; }

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
