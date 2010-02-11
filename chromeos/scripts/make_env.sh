#!/bin/bash

# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This script sets up a Gentoo chroot environment. The script is passed the
# path to an empty folder, which will be populated with a Gentoo stage3 and
# setup for development. Once created, the password is set to PASSWORD (below).
# One can enter the chrooted environment for work by running enter_chroot.sh.

# Load common constants.  This should be the first executable line.
# The path to common.sh should be relative to your script's location.
PROG=$(basename $0)
. "$(dirname "$0")/common.sh"

# Check if the host machine architecture is supported.
ARCHITECTURE="$(uname -m)"
if [[ "$ARCHITECTURE" != "x86_64" ]]; then
  echo "$PROG: $ARCHITECTURE is not supported as a host machine architecture."
  exit 1
fi

# Script must be run outside the chroot
assert_outside_chroot

# Define command line flags
# See http://code.google.com/p/shflags/wiki/Documentation10x

DEFINE_string chroot "$DEFAULT_CHROOT_DIR" \
  "Destination dir for the chroot environment."
DEFINE_boolean usepkg $FLAGS_TRUE "Use binary packages to bootstrap."
DEFINE_boolean delete $FLAGS_FALSE "Delete an existing chroot."
DEFINE_boolean replace $FLAGS_FALSE "Overwrite existing chroot, if any."
DEFINE_integer jobs -1 "How many packages to build in parallel at maximum."

# Parse command line flags
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"

# Only now can we die on error.  shflags functions leak non-zero error codes,
# so will die prematurely if 'set -e' is specified before now.
# TODO: replace shflags with something less error-prone, or contribute a fix.
set -e

FULLNAME="ChromeOS Developer"
DEFGROUPS="eng,adm,cdrom,floppy,audio,video,portage"
PASSWORD=chronos
CRYPTED_PASSWD=$(perl -e 'print crypt($ARGV[0], "foo")', $PASSWORD)

USEPKG=""
if [[ $FLAGS_usepkg -eq $FLAGS_TRUE ]]; then
  USEPKG="--getbinpkg --usepkg"
fi


function in_chroot {
  sudo chroot "$FLAGS_chroot" "$@"
}

function bash_chroot {
  # Use $* not $@ since 'bash -c' needs a single arg
  # Use -l to force source of /etc/profile (login shell)
  sudo chroot "$FLAGS_chroot" bash -l -c "$*"
}

function cleanup {
  # Clean up mounts
  mount | grep "on $(readlink -f "$FLAGS_chroot")" | awk '{print $3}' \
    | xargs -r -L1 sudo umount
}

function delete_existing {
  # Delete old chroot dir
  if [[ -e "$FLAGS_chroot" ]]; then
    echo "$PROG: Cleaning up old mount points..."
    cleanup
    echo "$PROG: Deleting $FLAGS_chroot..."
    sudo rm -rf "$FLAGS_chroot"
  fi
}

function init_users () {
   echo "$PROG: Adding user/group..."
   # Add ourselves as a user inside the chroot
   in_chroot groupadd -g 5000 eng
   in_chroot useradd -G ${DEFGROUPS} -g eng -u `id -u` -s \
     /bin/bash -m -c "${FULLNAME}" -p ${CRYPTED_PASSWD} ${USER}
}

function init_setup () {
   echo "Running init_setup()..."
   sudo mkdir -p "${FLAGS_chroot}/usr"
   sudo ln -sf "${CHROOT_TRUNK}/src/third_party/portage" \
     "${FLAGS_chroot}/usr/portage"
   sudo mkdir -p "${FLAGS_chroot}/usr/local/portage"
   sudo chmod 755 "${FLAGS_chroot}/usr/local/portage"
   sudo ln -sf "${CHROOT_TRUNK}/src/third_party/chromiumos-overlay" \
     "${FLAGS_chroot}"/"${CHROOT_OVERLAY}"

   # Some operations need an mtab
   in_chroot ln -s /proc/mounts /etc/mtab

   # Set up sudoers.  Inside the chroot, the user can sudo without a password.
   # (Safe enough, since the only way into the chroot is to 'sudo chroot', so
   # the user's already typed in one sudo password...)
   bash_chroot "echo %adm ALL=\(ALL\) ALL >> /etc/sudoers"
   bash_chroot "echo $USER ALL=NOPASSWD: ALL >> /etc/sudoers"
   bash_chroot chmod 0440 /etc/sudoers

   echo "$PROG: Setting up hosts/resolv..."
   # Copy config from outside chroot into chroot
   sudo cp /etc/hosts "$FLAGS_chroot/etc/hosts"
   sudo chmod 0644 "$FLAGS_chroot/etc/hosts"
   sudo cp /etc/resolv.conf "$FLAGS_chroot/etc/resolv.conf"
   sudo chmod 0644 "$FLAGS_chroot/etc/resolv.conf"

   # Setup host make.conf. This includes any overlay that we may be using
   # and a pointer to pre-built packages.
   # TODO: This should really be part of a profile in the portage
   echo "$PROG: Setting up /etc/make.*..."
   sudo mv "${FLAGS_chroot}"/etc/make.conf{,.orig}
   sudo ln -sf "${CHROOT_CONFIG}/make.conf.amd64-host" \
     "${FLAGS_chroot}/etc/make.conf"
   sudo mv "${FLAGS_chroot}"/etc/make.profile{,.orig}
   sudo ln -sf "${CHROOT_OVERLAY}/profiles/default/linux/amd64/10.0" \
     "${FLAGS_chroot}/etc/make.profile"

   # Create directories referred to by our conf files.
   sudo mkdir -p "${FLAGS_chroot}/var/lib/portage/distfiles"
   sudo mkdir -p "${FLAGS_chroot}/var/lib/portage/pkgs"

   if [[ $FLAGS_jobs -ne -1 ]]; then
     EMERGE_JOBS="--jobs=$FLAGS_jobs"
   fi

   # Configure basic stuff needed
   in_chroot env-update
   bash_chroot ls -l /etc/make.conf
   bash_chroot ls -l /etc/make.profile
   bash_chroot ls -l /usr/local/portage/chromiumos/profiles/default/linux/amd64/10.0

   # Niceties for interactive logins ('enter_chroot.sh'); these are ignored
   # when specifying a command to enter_chroot.sh.
   # Warn less when apt-get installing packqages
   echo "export LANG=C" >> "$FLAGS_chroot/home/$USER/.bashrc"
   echo "export PS1=\"(cros-chroot) \$PS1\"" >> "$FLAGS_chroot/home/$USER/.bashrc"
   chmod a+x "$FLAGS_chroot/home/$USER/.bashrc"
   # Automatically change to scripts directory
   echo "cd trunk/src/scripts" >> "$FLAGS_chroot/home/$USER/.bash_profile"

   # Warn if attempting to use source control commands inside the chroot
   for NOUSE in svn gcl gclient
   do
     echo "alias $NOUSE='echo In the chroot, it is a bad idea to run $NOUSE'" \
       >> "$FLAGS_chroot/home/$USER/.bash_profile"
   done

   if [[ "$USER" = "chrome-bot" ]]; then
     # Copy ssh keys, so chroot'd chrome-bot can scp files from chrome-web.
     cp -r ~/.ssh "$FLAGS_chroot/home/$USER/"
   fi
}

# Handle deleting an existing environment
if [[ $FLAGS_delete  -eq $FLAGS_TRUE || \
      $FLAGS_replace -eq $FLAGS_TRUE ]]; then
  delete_existing
  echo "$PROG: Done."
  exit 0
fi

CHROOT_TRUNK="${CHROOT_TRUNK_DIR}"
PORTAGE="${SRC_ROOT}/third_party/portage"
OVERLAY="${SRC_ROOT}/third_party/chromiumos-overlay"
CONFIG_DIR="${OVERLAY}/chromeos/config"
CHROOT_CONFIG="${CHROOT_TRUNK}/src/third_party/chromiumos-overlay/chromeos/config"
CHROOT_OVERLAY="/usr/local/portage/chromiumos"
CHROOT_STATE="${FLAGS_chroot}/etc/debian_chroot"

# Create the destination directory
mkdir -p "$FLAGS_chroot"

# Create the base Gentoo stage3 based on last version put in chroot
STAGE3="${OVERLAY}/chromeos/stage3/stage3-amd64-2009.10.09.tar.bz2"
if [ -f $CHROOT_STATE ] && \
  ! egrep -q "^STAGE3=$STAGE3" $CHROOT_STATE >/dev/null 2>&1
then
  echo "$PROG: STAGE3 version has changed."
  delete_existing
fi

echo
if [ -f $CHROOT_STATE ]
then
  echo "$PROG: STAGE3 already set up.  Skipping..."
else
  echo "$PROG: Unpacking STAGE3..."
  sudo tar xjp -C "$FLAGS_chroot" -f "$STAGE3"
fi

# Set up users, if needed, before mkdir/mounts below
[ -f $CHROOT_STATE ] || init_users

echo
echo "$PROG: Setting up mounts..."
# Set up necessary mounts and make sure we clean them up on exit
trap cleanup EXIT
sudo mkdir -p "${FLAGS_chroot}/${CHROOT_TRUNK}"
sudo mount --bind "${GCLIENT_ROOT}" "${FLAGS_chroot}/${CHROOT_TRUNK}"
sudo mount none -t proc "$FLAGS_chroot/proc"
sudo mount none -t devpts "$FLAGS_chroot/dev/pts"

if [ -f $CHROOT_STATE ];then
  echo "$PROG: chroot already initialized.  Skipping..."
else
  # run all the init stuff to setup the env
  init_setup
fi

# Add file to indicate that it is a chroot
# Add version of $STAGE3 for update checks
sudo sh -c "echo STAGE3=$STAGE3 > $CHROOT_STATE"

echo "$PROG: Running emerge world..."
bash_chroot emerge -uDNv $USEPKG world $EMERGE_JOBS
echo
echo "$PROG: Running emerge hard-host-depends..."
bash_chroot emerge -uDNv $USEPKG chromeos-base/hard-host-depends $EMERGE_JOBS

# Unmount trunk
sudo umount "${FLAGS_chroot}/${CHROOT_TRUNK}"

# Clean up the chroot mounts
trap - EXIT
cleanup

if [[ "$FLAGS_chroot" = "$DEFAULT_CHROOT_DIR" ]]; then
  CHROOT_EXAMPLE_OPT=""
else
  CHROOT_EXAMPLE_OPT="--chroot=$FLAGS_chroot"
fi

echo
echo "$PROG: All set up.  To enter the chroot, run:"
echo "$PROG: $ $SCRIPTS_DIR/enter_chroot.sh $CHROOT_EXAMPLE_OPT"
echo ""
echo "CAUTION: Do *NOT* rm -rf the chroot directory; if there are stale bind"
echo "mounts you may end up deleting your source tree too.  To unmount and"
echo "delete the chroot cleanly, use:"
echo "$ $0 --delete $CHROOT_EXAMPLE_OPT"
