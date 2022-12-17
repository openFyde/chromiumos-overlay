# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="569acd1eb0e5ee39f1e4b50921a0856c0b30f137"
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "e55257b9a88004c0939dedede6e557c4ba2db473" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/bundle .gn"

inherit cros-workon user

DESCRIPTION="Container to run Android."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/container/bundle"

LICENSE="BSD-Google"
KEYWORDS="*"

IUSE="
	android-container-rvc
	arcpp
	arcvm
	"

REQUIRED_USE="|| ( arcpp arcvm )"

RDEPEND="!<chromeos-base/chromeos-cheets-scripts-0.0.3"
DEPEND="${RDEPEND}"

CONTAINER_ROOTFS="/opt/google/containers/android/rootfs"

src_install() {
	if use arcpp; then
		insinto /opt/google/containers/android
		if use android-container-rvc; then
			doins arc/container/bundle/rvc/config.json
		else
			doins arc/container/bundle/pi/config.json
		fi

		# Install exception file for FIFO blocking policy on stateful partition.
		insinto /usr/share/cros/startup/fifo_exceptions
		doins arc/container/bundle/arc-fifo-exceptions.txt

		# Install exception file for symlink blocking policy on stateful partition.
		insinto /usr/share/cros/startup/symlink_exceptions
		doins arc/container/bundle/arc-symlink-exceptions.txt
	fi
}

pkg_preinst() {
	# ARCVM also needs these users on the host side for proper ugid remapping.
	enewuser "wayland"
	enewgroup "wayland"
	enewuser "arc-bridge"
	enewgroup "arc-bridge"
	enewuser "android-root"
	enewgroup "android-root"
	enewgroup "arc-sensor"
	enewgroup "android-everybody"
	enewgroup "android-reserved-disk"
}

pkg_postinst() {
	if use arcpp; then
		local root_uid=$(egetent passwd android-root | cut -d: -f3)
		local root_gid=$(egetent group android-root | cut -d: -f3)

		# Create a rootfs directory, and then a subdirectory mount point. We
		# use 0500 for CONTAINER_ROOTFS instead of 0555 so that non-system
		# processes running outside the container don't start depending on
		# files in system.raw.img.
		# These are created here rather than at
		# install because some of them may already exist and have mounts.
		install -d --mode=0500 "--owner=${root_uid}" "--group=${root_gid}" \
			"${ROOT}${CONTAINER_ROOTFS}" \
			|| true
		# This CONTAINER_ROOTFS/root directory works as a mount point for
		# system.raw.img, and once it's mounted, the image's root directory's
		# permissions override the mode, owner, and group mkdir sets here.
		mkdir -p "${ROOT}${CONTAINER_ROOTFS}/root" || true
		install -d --mode=0500 "--owner=${root_uid}" "--group=${root_gid}" \
			"${ROOT}${CONTAINER_ROOTFS}/android-data" \
			|| true
	fi
}
