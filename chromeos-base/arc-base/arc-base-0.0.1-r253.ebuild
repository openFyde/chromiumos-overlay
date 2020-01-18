# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fe6f9c6994aae4feb17707d091ebdd028ec081e3"
CROS_WORKON_TREE=("c0a80b9d7fcf566454e141f044b430fccf9fd33d" "d92e84f96bffe54d69b321bf93bcf851c2a64870" "6dcd9fca8295bf3dab87c84721b08d3f3aa1ec66" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container-bundle arc/scripts .gn"

inherit cros-workon user

DESCRIPTION="Container to run Android."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/container-bundle"

LICENSE="BSD-Google"
KEYWORDS="*"

# TODO(b/73695883): Rename from android-container-master-arc-dev to
# android-container-master.
IUSE="
	android-container-master-arc-dev
	android-container-nyc
	android-container-pi
	android-container-qt
	"

RDEPEND="!<chromeos-base/chromeos-cheets-scripts-0.0.3"
DEPEND="${RDEPEND}"

CONTAINER_ROOTFS="/opt/google/containers/android/rootfs"

src_install() {
	insinto /opt/google/containers/android
	if use android-container-master-arc-dev; then
		doins arc/container-bundle/master/config.json
	elif use android-container-qt; then
		doins arc/container-bundle/qt/config.json
	elif use android-container-pi; then
		doins arc/container-bundle/pi/config.json
	elif use android-container-nyc; then
		doins arc/container-bundle/nyc/config.json
	else
		echo "Unknown container version" >&2
		exit 1
	fi

	# Install scripts.
	insinto /etc/init
	doins arc/scripts/arc-stale-directory-remover.conf
	doins arc/scripts/arc-remove-data.conf

	insinto /etc/sysctl.d
	doins arc/scripts/01-sysctl-arc.conf

	insinto /etc/rsyslog.d
	doins arc/scripts/rsyslog.arc.conf

	# Install exception file for FIFO blocking policy on stateful partition.
	insinto /usr/share/cros/startup/fifo_exceptions
	doins arc/container-bundle/arc-fifo-exceptions.txt

	# Install exception file for symlink blocking policy on stateful partition.
	insinto /usr/share/cros/startup/symlink_exceptions
	doins arc/container-bundle/arc-symlink-exceptions.txt
}

pkg_preinst() {
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
}
