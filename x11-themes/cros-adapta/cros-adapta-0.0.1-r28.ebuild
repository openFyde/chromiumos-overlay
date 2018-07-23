# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="366ff2ee9f9771cef4c404e583f8a6e5e47ad12e"
CROS_WORKON_TREE="e274c9ffaec3f05ba5894401bdd1b96089727bfe"
CROS_WORKON_LOCALNAME="cros-adapta"
CROS_WORKON_PROJECT="chromiumos/third_party/cros-adapta"

inherit cros-workon

DESCRIPTION="GTK theme for the VM guest container for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/cros-adapta/"

LICENSE="GPL-2 CC-BY-4.0"
SLOT="0"
KEYWORDS="*"

src_install() {
	insinto /opt/google/cros-containers/cros-adapta
	doins -r gtk-2.0 gtk-3.0 gtk-3.22 index.theme

	# Install the assets directory if it exists.
	if [[ -d assets ]] ; then
		doins -r assets
	fi
}
