# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="8a2276f22f0678bee89b8ac6c46d9dd597c6d549"
CROS_WORKON_TREE="63742259a5cf31f0b2edc9898703985f9b877da5"
CROS_WORKON_PROJECT="chromiumos/platform/assets"
CROS_WORKON_LOCALNAME="platform/assets"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-workon

DESCRIPTION="Common Chromium OS assets (images, sounds, etc.)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/assets"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="
	+fonts
"

# display_boot_message calls the pango-view program.
RDEPEND="
	fonts? ( chromeos-base/chromeos-fonts )
	x11-libs/pango"

# Don't strip NaCl executables. These are not linux executables and the
# linux host's strip command doesn't know how to handle them correctly.
STRIP_MASK="*.nexe"

src_install() {
	insinto /usr/share/chromeos-assets/images
	doins -r images/*

	insinto /usr/share/chromeos-assets/images_100_percent
	doins -r images_100_percent/*

	insinto /usr/share/chromeos-assets/images_200_percent
	doins -r images_200_percent/*

	insinto /usr/share/chromeos-assets/text
	doins -r text/boot_messages
	dosbin text/display_boot_message

	# These files aren't used at runtime.
	find "${D}" -name '*.grd' -delete
}
