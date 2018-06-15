# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="fd4e8eef335ceaca7adf53a83f5e13e00e09101c"
CROS_WORKON_TREE="2827f58a8b066d629e1a0c4ca936e2c4f76a5b6b"
CROS_WORKON_PROJECT="chromiumos/platform/chromiumos-assets"
CROS_WORKON_LOCALNAME="chromiumos-assets"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-workon

DESCRIPTION="Chromium OS-specific assets"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/chromiumos-assets"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_install() {
	insinto /usr/share/chromeos-assets/images
	doins -r images/*

	insinto /usr/share/chromeos-assets/images_100_percent
	doins -r images_100_percent/*

	insinto /usr/share/chromeos-assets/images_200_percent
	doins -r images_200_percent/*
}
