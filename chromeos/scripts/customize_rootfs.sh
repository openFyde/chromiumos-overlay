#!/bin/bash

# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Script to customize the root file system after packages have been installed.
#
# NOTE: This is currently a dumping ground for for a bunch of hacks, some of
# which are to work around the fact that we are trying not to modify the base
# Chrome OS source when experimenting with this build system. Eventually most
# of this file should go away.
#

# Load common constants.  This should be the first executable line.
# The path to common.sh should be relative to your script's location.
. "$(dirname "$0")/common.sh"

# Script must be run inside the chroot
assert_inside_chroot

# Flags
DEFINE_string target "x86" \
  "The target architecture to build for. One of { x86, arm }."
DEFINE_string root ""      \
  "The root file system to customize."
DEFINE_boolean withdev $FLAGS_TRUE \
  "Include useful developer friendly utilities in the image."

# Parse command line
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"

# Die on any errors.
set -e

. "${SCRIPTS_DIR}/chromeos_version.sh"

ROOT_FS_DIR="$FLAGS_root"
if [[ -z "$ROOT_FS_DIR" ]]; then
  echo "Error: --root is required."
  exit 1
fi
if [[ ! -d "$ROOT_FS_DIR" ]]; then
  echo "Error: Root FS does not exist? ($ROOT_FS_DIR)"
  exit 1
fi

# Add entry to /etc/passwd
#
# $1 - Username (e.g. "messagebus")
# $2 - "*" to indicate not shadowed, "x" to indicate shadowed
# $3 - UID (e.g. 200)
# $4 - GID (e.g. 200)
# $5 - full name (e.g. "")
# $6 - home dir (e.g. "/home/foo" or "/var/run/dbus")
# $7 - shell (e.g. "/bin/sh" or "/bin/false")
add_user() {
  echo "${1}:${2}:${3}:${4}:${5}:${6}:${7}" | \
    sudo dd of="${ROOT_FS_DIR}/etc/passwd" conv=notrunc oflag=append
}

# Add entry to /etc/shadow
#
# $1 - Username
# $2 - Crypted password
add_shadow() {
  echo "${1}:${2}:14500:0:99999::::" | \
    sudo dd of="${ROOT_FS_DIR}/etc/shadow" conv=notrunc oflag=append
}

# Add entry to /etc/group
# $1 - Groupname (e.g. "messagebus")
# $2 - GID (e.g. 200)
add_group() {
  echo "${1}:x:${2}:" | \
    sudo dd of="${ROOT_FS_DIR}/etc/group" conv=notrunc oflag=append
}

# TODO: Image is missing some key directories. What package is supposed to
# create them?
sudo chmod 0755 "${ROOT_FS_DIR}/."
sudo mkdir -p "${ROOT_FS_DIR}/dev"
sudo mkdir -p "${ROOT_FS_DIR}/home"
sudo mkdir -p "${ROOT_FS_DIR}/proc"
sudo mkdir -p "${ROOT_FS_DIR}/root"
sudo mkdir -p "${ROOT_FS_DIR}/sys"
sudo mkdir -p "${ROOT_FS_DIR}/var/lock"

# On boot we mount the stateful partition here:
sudo mkdir -p "${ROOT_FS_DIR}/mnt/stateful_partition"

# TODO: Temporarily pre-seed the devices in /dev for debugging purposes.
sudo cp -a "${ROOT_FS_DIR}/lib/chromiumos/devices/"* "${ROOT_FS_DIR}/dev"

# TODO: Temporary until we stop the Upstart ebuild from installing any
# default init scripts and fix up the chromeos-init ebuild.
sudo rm -rf "${ROOT_FS_DIR}/etc/init"
sudo mv "${ROOT_FS_DIR}/etc/init.chromiumos" \
  "${ROOT_FS_DIR}/etc/init"

# Create getty on tty2
# TODO: Move this into platform/init and fix "start on" clause.
cat <<EOF | sudo dd of="$ROOT_FS_DIR"/etc/init/tty2.conf
start on startup
stop on starting halt or starting reboot

respawn
exec /sbin/agetty 38400 tty2 linux
EOF

# Set up a default dev user and add to sudo and the video groups.
# TODO: Make the default user (and password) customizeable
# TODO: Make the default user conditional on building a dev image.
DEV_USER="chronos"
DEV_UID="1000"
SHELL="/bin/sh"
if [[ -x "${ROOT_FS_DIR}/bin/bash" ]] ; then
  SHELL="/bin/bash"
fi
add_user "${DEV_USER}" "x" "${DEV_UID}" "${DEV_UID}" "dev_user" \
  "/home/${DEV_USER}" "$SHELL"
add_shadow "${DEV_USER}" ""
add_group "${DEV_USER}" "${DEV_UID}"
sudo mkdir -p "${ROOT_FS_DIR}/home/${DEV_USER}"
sudo chown "${DEV_UID}.${DEV_UID}" "${ROOT_FS_DIR}/home/${DEV_USER}"
cat <<EOF | sudo dd of="${ROOT_FS_DIR}/etc/sudoers" conv=notrunc oflag=append
%adm ALL=(ALL) ALL
$DEV_USER ALL=NOPASSWD: ALL
EOF
sudo chmod 0440 "${ROOT_FS_DIR}/etc/sudoers"

# Add the dev user to the video group
sudo sed -i "{ s/video::27:root/video::27:root,${DEV_USER}/ }" \
  "${ROOT_FS_DIR}/etc/group"

# TODO: Since the stateful partition may not have a chronos home directory
# on it, we create one here if necessary.
cat <<EOF | sudo dd of="$ROOT_FS_DIR"/etc/init/homedir.conf
start on stopped startup

task
script

if [ ! -d "/home/$DEV_USER" ]; then
  mkdir "/home/$DEV_USER"
  chown $DEV_USER.$DEV_USER "/home/$DEV_USER"
fi

end script
EOF

# Add messagebus user for dbus; grab uid/gid values from host system.
MB_UID=$(id -u "messagebus")
MB_GID=$(id -g "messagebus")
add_user "messagebus" "*" ${MB_UID} ${MB_GID} "dbus_user" /dev/null /bin/false
add_group "messagebus" ${MB_GID}

# Add ntp user for ntp
add_user "ntp" "*" 102 102 "ntp_user" /dev/null /bin/false
add_group "ntp" 102

# Add syslog user for rsyslog
add_user "syslog" "*" 103 103 "syslog_user" /dev/null /bin/false
add_group "syslog" 103

# Add mtab
sudo ln -s /proc/mounts "${ROOT_FS_DIR}/etc/mtab"

# The above initscripts expect some binaries to be in a different location
# TODO: Remove after this is fixed in the initscripts.
sudo ln -s /usr/bin/dbus-uuidgen "${ROOT_FS_DIR}/bin/dbus-uuidgen"
sudo ln -s /usr/bin/dbus-daemon "${ROOT_FS_DIR}/bin/dbus-daemon"

# TODO: Remove this after we are building our own wpa_supplicant. Also, on
# the ARM build for some reason this symlink is already there?
! sudo ln -s /usr/sbin/wpa_supplicant "${ROOT_FS_DIR}/sbin/wpa_supplicant"

# The gtk++ library has the wrong path when it dlopens some modules
sudo ln -s /usr/lib "${ROOT_FS_DIR}/usr/lib64"

# TODO: Temporarily create fake xterm symlink until we do proper xinitrc
ATERM="${ROOT_FS_DIR}/usr/bin/aterm"
if [[ -f "${ATERM}" ]]; then
  sudo chmod 0755 "${ROOT_FS_DIR}/usr/bin/aterm"
  sudo ln -s aterm "${ROOT_FS_DIR}/usr/bin/xterm"
fi

# TODO: Until libGL.so is fixed, create symlink libGL.so.1 -> libGL.so
sudo ln -s libGL.so "${ROOT_FS_DIR}/usr/lib/libGL.so.1"

# TODO: Until xkb is reconfigured for its stateful directory
sudo rm -rf "${ROOT_FS_DIR}/var/lib/xkb"
sudo ln -s /var/cache "${ROOT_FS_DIR}/var/lib/xkb"

# TODO: If slim is not installed, we fake it out so that our init script
# will return a success result.
if [[ ! -f "${ROOT_FS_DIR}/usr/bin/slim" ]]; then
  sudo ln -s /bin/true "${ROOT_FS_DIR}/usr/bin/slim"
fi

# TODO: until we switch away from the old build altogether
sudo mkdir -p  "${ROOT_FS_DIR}/usr/bin/X11"
sudo ln -s  /usr/bin/Xorg  "${ROOT_FS_DIR}/usr/bin/X11/X"

# TODO: until we get the login logic into chrome itself.
SESSION="${ROOT_FS_DIR}/opt/google/chrome/session"
# The arm build may not have chrome and its helper binaries yet
if [[ -f "${SESSION}" ]]; then
  sudo chown "root:${DEV_UID}" "${SESSION}"
  sudo chmod 6711 "${SESSION}"
fi

# Setup our xorg.conf. This allows us to avoid HAL overhead.
# TODO: Note that this is different from the latest chromeos one for now.
if [ -d "${ROOT_FS_DIR}/etc/X11" ]; then
  cat <<EOF | sudo dd of="$ROOT_FS_DIR"/etc/X11/xorg.conf
Section "ServerFlags"
    Option "AutoAddDevices" "false"
    Option "DontZap" "false"
EndSection

Section "InputDevice"
    Identifier "Keyboard1"
    Driver     "kbd"
    Option     "AutoRepeat" "250 30"
    Option     "XkbRules"   "xorg"
    Option     "XkbModel"   "pc104"
    Option     "CoreKeyboard"
EndSection

Section "InputDevice"
        Identifier "Mouse1"
        Driver     "synaptics"
        Option     "SendCoreEvents" "true"
        Option     "Protocol" "auto-dev"
        Option     "HorizScrollDelta"  "0"
        Option     "SHMConfig" "on"
        Option     "CorePointer"
        Option     "TapButton1" "1"
        Option     "TapButton2" "2"
EndSection

EOF
fi

# If dash is installed then we want to use that as our default /bin/sh
if [[ -x "${ROOT_FS_DIR}/bin/dash" ]] ; then
  sudo ln -sf dash "${ROOT_FS_DIR}/bin/sh"
fi

# If vim is installed, then a vi symlink would probably help
if [[ -x "${ROOT_FS_DIR}/usr/bin/vim" ]] ; then
  sudo ln -sf vim "${ROOT_FS_DIR}/usr/bin/vi"
fi

# If mawk is installed, awk should symlink to that.
# TODO: Maybe fix this by using a virtual/awk?
if [[ -x "${ROOT_FS_DIR}/usr/bin/mawk" ]] ; then
  sudo ln -sf mawk "${ROOT_FS_DIR}/usr/bin/awk"
fi

# TODO(msb): Ugly Hack fix for pango-querymodules
# pango-querymodules needs to be run on the target so we ran it on the target
# and stored the result which we copy here
CHROMIUMOS_OVERLAY="/usr/local/portage/chromiumos"
sudo cp "${CHROMIUMOS_OVERLAY}/chromeos/files/pango.modules" \
  "${ROOT_FS_DIR}"/etc/pango/
sudo chmod 0644 "${ROOT_FS_DIR}"/etc/pango/pango.modules

# TODO: This is a temporary script to start chromeos chrome.
cat <<"EOF" | sudo dd of="$ROOT_FS_DIR"/usr/bin/chromeos-chrome
#!/bin/sh

exec /opt/google/chrome/chrome
EOF
sudo chmod +x "$ROOT_FS_DIR"/usr/bin/chromeos-chrome

# dbus-uuidgen writes machine-id to /var/lib/dbus.
sudo rm -rf "${ROOT_FS_DIR}/var/lib/dbus"
sudo ln -s /var/cache "${ROOT_FS_DIR}/var/lib/dbus"

# Write stock lsb-release file
# Set CHROMEOS_VERSION_DESCRIPTION here (uses vars set in chromeos_version.sh)# Was removed from chromeos_version.sh which can also be run outside of chroot
# where CHROMEOS_REVISION is set
# We have to set (in build_image.sh) and use REAL_USER due to many nested
# chroots which lose $USER state.. "${SCRIPTS_DIR}/chromeos_version.sh"
if [ ${CHROMEOS_OFFICIAL:-0} = 1 ]; then
  export CHROMEOS_VERSION_DESCRIPTION="${CHROMEOS_VERSION_STRING} (Official Buil
d ${CHROMEOS_REVISION:?})"
elif [ "$REAL_USER" = "chrome-bot" ]
then
  export CHROMEOS_VERSION_DESCRIPTION="${CHROMEOS_VERSION_STRING} (Continuous Bu
ild ${CHROMEOS_REVISION:?} - Builder: ${BUILDBOT_BUILD:-"N/A"})"
else
  # Use the $USER passthru via $CHROMEOS_RELEASE_CODENAME
  export CHROMEOS_VERSION_DESCRIPTION="${CHROMEOS_VERSION_STRING} (Developer Build ${CHROMEOS_REVISION:?} - $(date) - $CHROMEOS_RELEASE_CODENAME)"
fi

# Set google-specific version numbers:
# CHROMEOS_RELEASE_CODENAME is the codename of the release.
# CHROMEOS_RELEASE_DESCRIPTION is the version displayed by Chrome; see
#   chrome/browser/chromeos/chromeos_version_loader.cc.
# CHROMEOS_RELEASE_NAME is a human readable name for the build.
# CHROMEOS_RELEASE_TRACK and CHROMEOS_RELEASE_VERSION are used by the software
#   update service.
# TODO(skrul):  Remove GOOGLE_RELEASE once Chromium is updated to look at
#   CHROMEOS_RELEASE_VERSION for UserAgent data.
cat <<EOF | sudo dd of="${ROOT_FS_DIR}/etc/lsb-release"
CHROMEOS_RELEASE_CODENAME=$CHROMEOS_VERSION_CODENAME
CHROMEOS_RELEASE_DESCRIPTION=$CHROMEOS_VERSION_DESCRIPTION
CHROMEOS_RELEASE_NAME=$CHROMEOS_VERSION_NAME
CHROMEOS_RELEASE_TRACK=$CHROMEOS_VERSION_TRACK
CHROMEOS_RELEASE_VERSION=$CHROMEOS_VERSION_STRING
GOOGLE_RELEASE=$CHROMEOS_VERSION_STRING
CHROMEOS_AUSERVER=$CHROMEOS_VERSION_AUSERVER
CHROMEOS_DEVSERVER=$CHROMEOS_VERSION_DEVSERVER
EOF
