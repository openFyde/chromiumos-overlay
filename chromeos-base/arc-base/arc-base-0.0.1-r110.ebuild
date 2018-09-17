# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="df756b2ca89469cebcc34506225e0b068c5fb846"
CROS_WORKON_TREE=("76fa0ea78e7e7fde86f2c3fc18d6fba87c4122b7" "30c679333d3c95b8bf3ebc0f1fcaf86853d8bbdc" "911b65b43bbc8fa0138bc20e2b85fb858fd10344" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container-bundle arc/scripts .gn"

inherit cros-workon user

DESCRIPTION="Container to run Android."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/container-bundle"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

# TODO(b/73695883): Rename from android-container-master-arc-dev to
# android-container-master.
IUSE="
	android-container-master-arc-dev
	android-container-nyc
	android-container-pi
	"

RDEPEND="!<chromeos-base/chromeos-cheets-scripts-0.0.3"
DEPEND="${RDEPEND}"

CONTAINER_ROOTFS="/opt/google/containers/android/rootfs"

src_install() {
	insinto /opt/google/containers/android
	if use android-container-master-arc-dev; then
		doins arc/container-bundle/master/config.json
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

	insinto /etc/sysctl.d
	doins arc/scripts/01-sysctl-arc.conf

	insinto /etc/rsyslog.d
	doins arc/scripts/rsyslog.arc.conf

	dosbin arc/scripts/android-sh
	dobin arc/scripts/collect-cheets-logs

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
