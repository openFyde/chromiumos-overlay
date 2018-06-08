# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="c31f815e0f88cc6b0280b7a9f4f994e1084d53f9"
CROS_WORKON_TREE=("1d995a5f11b89f06713e6b213ea3f8741ace4008" "4d03c033d5e044ca994c026bbd5e0b5dc734eeef" "c285f3736e885f789c3207f7e697933104f04e7c")
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

# Creates dalvik-cache/ and its isa/ directories.
create_dalvik_cache_isa_dir() {
	local dalvik_cache_dir="${ROOT}${CONTAINER_ROOTFS}/android-data/data/dalvik-cache"

	install -d --mode=0555 --owner=root --group=root \
		"${dalvik_cache_dir}" || true
	install -d --mode=0555 --owner=root --group=root \
		"${dalvik_cache_dir}/x86" || true
	install -d --mode=0555 --owner=root --group=root \
		"${dalvik_cache_dir}/x86_64" || true
	install -d --mode=0555 --owner=root --group=root \
		"${dalvik_cache_dir}/arm" || true
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

	# Create /cache and /data directories. These are used when the container
	# is started for login screen as empty and readonly directories. To make
	# the directory not writable from the container even when / is remounted
	# with 'rw', use host's root as --owner and --group.
	install -d --mode=0555 --owner=root --group=root \
		"${ROOT}${CONTAINER_ROOTFS}/android-data/cache" \
		|| true
	install -d --mode=0555 --owner=root --group=root \
		"${ROOT}${CONTAINER_ROOTFS}/android-data/data" \
		|| true

	# master also needs /data/cache as a mount point. To make images look
	# similar, do the same for N too.
	install -d --mode=0555 --owner=root --group=root \
		"${ROOT}${CONTAINER_ROOTFS}/android-data/data/cache" \
		|| true

	# Create /data/dalvik-cache/<isa> directories so that we can start zygote
	# for the login screen.
	create_dalvik_cache_isa_dir
}
