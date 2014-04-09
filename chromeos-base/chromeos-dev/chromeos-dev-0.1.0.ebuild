
# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Adds some developer niceties on top of Chrome OS for debugging"
HOMEPAGE="http://src.chromium.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="cras pam opengl +profile tpm usb X"

# The dependencies here are meant to capture "all the packages
# developers want to use for development, test, or debug".  This
# category is meant to include all developer use cases, including
# software test and debug, performance tuning, hardware validation,
# and debugging failures running autotest.
#
# To protect developer images from changes in other ebuilds you
# should include any package with a user constituency, regardless of
# whether that package is included in the base Chromium OS image or
# any other ebuild.
#
# Don't include packages that are indirect dependencies: only
# include a package if a file *in that package* is expected to be
# useful.

################################################################################
#
# CROS_* : Dependencies for CrOS devices (coreutils, X etc)
#
################################################################################
CROS_X86_RDEPEND="
	app-benchmarks/i7z
	dev-util/turbostat
	sys-apps/dmidecode
	sys-apps/pciutils
	x11-apps/intel-gpu-tools
"

CROS_X_RDEPEND="
	opengl? ( x11-apps/mesa-progs )
	x11-apps/mtplot
	x11-apps/xdpyinfo
	opengl? ( x11-apps/xdriinfo )
	x11-apps/xev
	x11-apps/xhost
	x11-apps/xinput
	x11-apps/xinput_calibrator
	x11-apps/xlsatoms
	x11-apps/xlsclients
	x11-apps/xmodmap
	x11-apps/xprop
	x11-apps/xset
	!x11-apps/xtrace
	x11-apps/xwd
	x11-apps/xwininfo
	x11-misc/xdotool
	x11-misc/xtrace
"

RDEPEND="
	x86? ( ${CROS_X86_RDEPEND} )
	amd64? ( ${CROS_X86_RDEPEND} )
	X? ( ${CROS_X_RDEPEND} )
"

RDEPEND="${RDEPEND}
	pam? ( app-admin/sudo )
	app-admin/sysstat
	app-arch/gzip
	app-arch/tar
	profile? (
		app-benchmarks/punybench
		dev-util/libc-bench
		net-analyzer/netperf
		dev-util/perf
	)
	app-crypt/nss
	tpm? ( app-crypt/tpm-tools )
	app-editors/qemacs
	app-editors/vim
	app-misc/evtest
	app-misc/screen
	app-portage/portage-utils
	app-shells/bash
	cras? (
		chromeos-base/audiotest
		media-sound/sox
	)
	chromeos-base/chromeos-dev-root
	chromeos-base/gmerge
	chromeos-base/platform2
	chromeos-base/protofiles
	chromeos-base/shill-test-scripts
	chromeos-base/wireless_automation
	net-analyzer/tcpdump
	net-dialup/minicom
	net-misc/dhcp
	net-misc/iperf
	net-misc/iputils
	net-misc/openssh
	net-misc/rsync
	net-wireless/iw
	net-wireless/wireless-tools
	dev-lang/python
	dev-libs/protobuf-python
	dev-python/cherrypy
	dev-python/dbus-python
	dev-util/hdctools
	dev-util/mem
	dev-util/strace
	media-sound/sox
	net-dialup/lrzsz
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/file
	sys-apps/findutils
	sys-apps/i2c-tools
	sys-apps/iotools
	sys-apps/kbd
	sys-apps/less
	sys-apps/mmc-utils
	sys-apps/smartmontools
	usb? ( sys-apps/usbutils )
	sys-apps/which
	sys-block/fio
	sys-devel/gdb
	sys-fs/fuse
	sys-fs/lvm2
	sys-fs/sshfs-fuse
	sys-power/powertop
	sys-process/ktop
	sys-process/procps
	sys-process/psmisc
	sys-process/time
	virtual/chromeos-bsp-dev
"

DEPEND="${RDEPEND}"
