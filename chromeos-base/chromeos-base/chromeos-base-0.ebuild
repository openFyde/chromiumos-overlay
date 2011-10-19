# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

inherit useradd

DESCRIPTION="ChromeOS specific system setup"
HOMEPAGE="http://src.chromium.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND=">=sys-apps/baselayout-2.0.1-r226"
RDEPEND="${DEPEND}
	!<sys-libs/timezone-data-2011d"

# Adds a "daemon"-type user with no login or shell.
copy_or_add_daemon_user() {
	local username="$1"
	local uid="$2"
	copy_or_add_user "${username}" "*" $uid $uid "" /dev/null /bin/false
	copy_or_add_group "${username}" $uid
}

pkg_setup() {
	# The sys-libs/timezone-data package installs a default /etc/localtime
	# file automatically, so scrub that if it's a regular file.
	local etc_tz="${ROOT}etc/localtime"
	[[ -L ${etc_tz} ]] || rm -f "${etc_tz}"
}

src_install() {
	insinto /etc/profile.d
	doins "${FILESDIR}"/xauthority.sh || die

	# Symlink /etc/localtime to something on the stateful partition, which we
	# can then change around at runtime.
	dosym /var/lib/timezone/localtime /etc/localtime
}

pkg_postinst() {
	local x

	# We explicitly add all of the users needed in the system here. The
	# build of Chromium OS uses a single build chroot environment to build
	# for various targets with distinct ${ROOT}. This causes two problems:
	#   1. The target rootfs needs to have the same UIDs as the build
	#      chroot so that chmod operations work.
	#   2. The portage tools to add a new user in an ebuild don't work when
	#      $ROOT != /
	# We solve this by having baselayout install in both the build and
	# target and pre-create all needed users. In order to support existing
	# build roots we copy over the user entries if they already exist.
	local system_user="chronos"
	local system_id="1000"
	local system_home="/home/${system_user}/user"

	local crypted_password='*'
	[ -r "${SHARED_USER_PASSWD_FILE}" ] &&
		crypted_password=$(cat "${SHARED_USER_PASSWD_FILE}")
	remove_user "${system_user}"
	add_user "${system_user}" "x" "${system_id}" \
		"${system_id}" "system_user" "${system_home}" /bin/sh
	remove_shadow "${system_user}"
	add_shadow "${system_user}" "${crypted_password}"

	copy_or_add_group "${system_user}" "${system_id}"
	copy_or_add_daemon_user "messagebus" 201  # For dbus
	copy_or_add_daemon_user "syslog" 202      # For rsyslog
	copy_or_add_daemon_user "ntp" 203
	copy_or_add_daemon_user "sshd" 204
	copy_or_add_daemon_user "pulse" 205       # For pulseaudio
	copy_or_add_daemon_user "polkituser" 206  # For policykit
	copy_or_add_daemon_user "tss" 207         # For trousers (TSS/TPM)
	copy_or_add_daemon_user "pkcs11" 208      # For opencryptoki
	copy_or_add_daemon_user "qdlservice" 209  # for QDLService
	copy_or_add_daemon_user "cromo" 210	  # For cromo (modem manager)
	copy_or_add_daemon_user "cashew" 211      # For cashew (network usage)
	copy_or_add_daemon_user "ipsec" 212       # For strongswan/ipsec VPN
	copy_or_add_daemon_user "cros-disks" 213  # For cros-disks
	copy_or_add_daemon_user "tor" 214         # For tor (anonymity service)
	copy_or_add_daemon_user "tcpdump" 215     # For tcpdump --with-user
	# Reserve some UIDs/GIDs between 300 and 349 for sandboxing FUSE-based
	# filesystem daemons.
	copy_or_add_daemon_user "ntfs-3g" 300     # For ntfs-3g

	# The system_user needs to be part of the audio and video groups.
	test $(grep -e "^audio\:" "${ROOT}/etc/group" | \
		grep "${system_user}") || \
		sed -i "{ s/audio::18:\(.*\)/audio::18:\1,${system_user}/ }" \
			"${ROOT}/etc/group"
	test $(grep -e "^video\:" "${ROOT}/etc/group" | \
		grep "${system_user}") || \
		sed -i "{ s/video::27:\(.*\)/video::27:\1,${system_user}/ }" \
			"${ROOT}/etc/group"

	# The root, ipsec and ${system_user} users must be in the pkcs11 group,
	# which must have the group id 208.
	sed -i "{ s/pkcs11:x:.*/pkcs11:x:208:root,ipsec,${system_user}/ }" \
		"${ROOT}/etc/group"

	# Some default directories. These are created here rather than at
	# install because some of them may already exist and have mounts.
	for x in /dev /home /media \
		/mnt/stateful_partition /proc /root /sys /var/lock; do
		[ -d "${ROOT}/$x" ] && continue
		install -d --mode=0755 --owner=root --group=root "${ROOT}/$x"
	done

	# We add an entry for www35.vzw.com to /etc/hosts to work around bug
	# http://crosbug.com/p/4279
	cat <<-EOF >> "${ROOT}"/etc/hosts

	# http://crosbug.com/p/4279
	127.0.0.1	www35.vzw.com
	EOF
}
