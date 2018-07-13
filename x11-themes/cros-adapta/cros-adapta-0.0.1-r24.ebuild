# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="5a7472bc9ba101256341f24a295ea7af56c0d6c4"
CROS_WORKON_TREE="d1e088ba27f40a9e2e0e7d26e8e1130be2ef2df2"
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
