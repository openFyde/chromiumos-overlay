# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="773ac7d0e6efd8d06b7190c7ec28ca2e2bade96d"
CROS_WORKON_TREE=("6dd24c3358b82474c558c65a0d6e0d3f3d9193c4" "c9f93d2c26681868d7021028b18bee5bd5120986" "e04a446fe49f58d86acbe0f17e4917c69ad414ce")
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

	# Create a 0700 directory, and then a subdirectory mount point.
	# These are created here rather than at
	# install because some of them may already exist and have mounts.
	install -d --mode=0700 --owner=${root_uid} --group=${root_gid} \
		"${ROOT}${CONTAINER_ROOTFS}" \
		|| true
	install -d --mode=0700 --owner=${root_uid} --group=${root_gid} \
		"${ROOT}${CONTAINER_ROOTFS}/root" \
		|| true
	install -d --mode=0755 --owner=root --group=root \
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
