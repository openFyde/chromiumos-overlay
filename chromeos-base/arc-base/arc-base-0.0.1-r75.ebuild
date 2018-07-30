# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="1cfc96f72611bd20e3833406b68bba8ae544d2f3"
CROS_WORKON_TREE=("34bcb6266df551e7744073b28ff1b6aa18023fe2" "431e861fb5a10547f74cdf4a0fe13137845da241" "2fd9b9f748c628bcb2fcaafd07096929fe2cef3a")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container-bundle arc/scripts"

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
	doins arc/scripts/arc-setfattr.conf
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
