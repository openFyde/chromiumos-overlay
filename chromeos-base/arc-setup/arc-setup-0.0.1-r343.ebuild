# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="2a559712174dbf6cbda845c196882709d352a62f"
CROS_WORKON_TREE=("56c75aa73108d344f9441f26855f37e4c4838dd3" "274ef41a79a0d7c54cf561f14e44a5429ef15195" "5288af5163cf2bf921961cba53d929936c4b74f7" "a7ffd6cef4baefb8c0d32e55132eeeb90c842e4f" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk arc/setup chromeos-config metrics .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="arc/setup"
PLATFORM_GYP_FILE="arc-setup.gyp"

inherit cros-board cros-workon platform

DESCRIPTION="Set up environment to run ARC."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/setup"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="
	android-container-nyc
	esdfs
	houdini
	ndk_translation
	unibuild"

RDEPEND="
	chromeos-base/bootstat
	!<chromeos-base/chromeos-cheets-scripts-0.0.4
	unibuild? ( chromeos-base/chromeos-config )
	chromeos-base/chromeos-config-tools
	chromeos-base/cryptohome-client
	chromeos-base/libbrillo
	chromeos-base/metrics
	chromeos-base/minijail
	chromeos-base/swap-init
	sys-libs/libselinux
	dev-libs/dbus-glib
	dev-libs/protobuf
	esdfs? ( sys-apps/restorecon )"

DEPEND="${RDEPEND}
	chromeos-base/system_api"


set_density_scale() {
	local density=160
	# Scale is passed in percent
	local scale=100
	case $(get_current_board_with_variant) in
		chell*|nocturne*) # 2.25x. Among the standard Android dpi, the closest value 280 is chosen.
			density=280
			scale=225 ;;
		betty*|caroline*|eve*|kevin*|newbie*|novato*|samus*|scarlet*|soraka*) # 2x HiDPI
			density=240
			scale=200 ;;
		nautilus*) # 1.6x. Among the standard Android dpi, the closest value 213 is chosen.
			density=213
			scale=160 ;;
		grunt*) # 1x.  Set here to avoid being picked up by gru* below.
			density=160
			scale=100 ;;
		cave*|elm*|gru*) # 1.25x default scaling
			density=160
			scale=125 ;;
		cyan*|veyron_minnie*) # 1x
			density=160
			scale=100 ;;
		*)
			ewarn "Unknown board - using default pixel density of -1" ;;
	esac
	[[ -f "$1" ]] || die
	local data=$(jq ".ARC_LCD_DENSITY=${density}|.ARC_UI_SCALE=${scale}" "$1")
	echo "${data}" > "$1" || die
}

enable_esdfs() {
	[[ -f "$1" ]] || die
	local data=$(jq ".USE_ESDFS=true" "$1")
	echo "${data}" > "$1" || die
}


src_install() {
	dosbin "${OUT}"/arc-setup

	insinto /etc/init
	doins etc/arc-boot-continue.conf
	if use esdfs; then
		doins etc/arc-sdcard.conf
		doins etc/arc-sdcard-mount.conf
	fi
	doins etc/arc-kmsg-logger.conf
	doins etc/arc-lifetime.conf
	doins etc/arc-sensor.conf
	doins etc/arc-start-sysctl.conf
	doins etc/arc-stop-sysctl.conf
	doins etc/arc-system-mount.conf
	doins etc/arc-update-restorecon-last.conf
	doins etc/arc-ureadahead.conf
	doins etc/arc-ureadahead-trace.conf

	insinto /usr/share/arc-setup
	doins etc/config.json

	set_density_scale "${D}/usr/share/arc-setup/config.json"
	if use esdfs; then
		enable_esdfs "${D}/usr/share/arc-setup/config.json"
	fi

	insinto /opt/google/containers/arc-art
	doins "${OUT}/dev-rootfs.squashfs"

	# container-root is where the root filesystem of the container in which
	# patchoat and dex2oat runs is mounted. dev-rootfs is mount point
	# for squashfs.
	diropts --mode=0700 --owner=root --group=root
	keepdir /opt/google/containers/arc-art/mountpoints/container-root
	keepdir /opt/google/containers/arc-art/mountpoints/dev-rootfs
	keepdir /opt/google/containers/arc-art/mountpoints/vendor
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-setup_testrunner"
}
