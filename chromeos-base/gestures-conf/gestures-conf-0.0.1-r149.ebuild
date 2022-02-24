# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="947b0fe90f19bd1e69a0e7692891b7a88e2b71f5"
CROS_WORKON_TREE="cb60c936877f2e933b02e277aa12fde33c24c79b"
CROS_WORKON_LOCALNAME="platform/xorg-conf"
CROS_WORKON_PROJECT="chromiumos/platform/xorg-conf"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-board cros-workon user

DESCRIPTION="Board specific gestures library configuration file."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/xorg-conf/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="elan"

RDEPEND="!chromeos-base/touchpad-linearity"
DEPEND=""

src_install() {
	local board=$(get_current_board_no_variant)
	local board_variant=$(get_current_board_with_variant)

	insinto /etc/gesture

	# Some boards have experimental variants, such as -cheets, -arcnext,
	# -campfire, -kvm, -kernelnext or -arm64, which are running on the same
	# hardware as their base boards. As opposed to board variants, which use
	# underscore to separate from board name, they use a dash, so we can just
	# strip anything matching.
	board_variant=${board_variant%%-*}
	board=${board%%-*}

	# Enable exactly one evdev-compatible X input touchpad driver.
	#
	# Note: If possible, use the following xorg config names to allow
	# this ebuild to install them automatically:
	#    - 50-touchpad-cmt-$BOARD.conf
	#    - 60-touchpad-cmt-$BOARD_VARIANT.conf
	# e.g. daisy_skate will include the files:
	#    - 50-touchpad-cmt-daisy.conf
	#    - 60-touchpad-cmt-daisy_skate.conf
	doins 40-touchpad-cmt.conf
	if use elan; then
		doins 50-touchpad-cmt-elan.conf
	elif [[ "${board}" = "reven" ]]; then
		doins 50-touchpad-cmt-reven.conf
		# Since reven could be run on Chrome OS devices, it may as well
		# include configs for their touchpads, so long as those configs
		# have MatchDMIProduct lines.
		doins 50-touchpad-cmt-samus.conf
	else
		if [ -f "50-touchpad-cmt-${board}.conf" ]; then
			doins "50-touchpad-cmt-${board}.conf"
		fi
		if [ -f "60-touchpad-cmt-${board_variant}.conf" ]; then
			doins "60-touchpad-cmt-${board_variant}.conf"
		fi
	fi
	doins 20-mouse.conf

	insinto "/usr/share/gestures"
	case ${board} in
	daisy)
		doins "files/daisy_linearity.dat" ;;
	esac
}
