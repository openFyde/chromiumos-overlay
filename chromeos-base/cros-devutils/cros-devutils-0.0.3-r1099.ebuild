# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="8a1ecd4deb6095d4e5a474c1f4ca6902143ba560"
CROS_WORKON_TREE="fb27d3862545f98201ad1e44c7617579e61015ab"
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
	dev-util/crosutils
	dev-util/toolchain-utils
	sys-apps/flashmap
	"
# These are all either bash / python scripts.  No actual builds DEPS.
DEPEND=""

src_install() {
	dosym /build /var/lib/devserver/static/pkgroot
	dosym /var/lib/devserver/static /usr/lib/devserver/static

	local host_tools=(
		cros_choose_profile
		cros_chrome_make
		cros_workon_make
		netboot_firmware_settings.py
		strip_package
		willis
	)
	dobin "${host_tools[@]/#/host/}"

	# Payload generation scripts.
	dobin host/cros_generate_update_payload
	dobin host/cros_generate_stateful_update_payload

	# Repo and git bash completion.
	insinto /usr/share/bash-completion
	newins host/repo_bash_completion repo
	dosym /usr/share/bash-completion/repo /etc/bash_completion.d/repo
	dosym /usr/share/bash-completion/completions/git /etc/bash_completion.d/git
}

src_test() {
	cd "${S}" # Let's just run unit tests from ${S} rather than install and run.

	local TESTS=(
		autoupdate_unittest.py
		builder_test.py
		common_util_unittest.py
	)
	local test
	for test in "${TESTS[@]}" ; do
		einfo "Running ${test}"
		./${test} || die "Failed in ${test}"
	done
}
