# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="List of packages that are needed for Chrome OS factory software."
HOMEPAGE="http://dev.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+shill X"

################################################################################

# Packages for factory framework ("Goofy"):
FACTORY_FRAMEWORK_RDEPEND="
	shill? ( chromeos-base/shill-test-scripts )
	dev-lang/python
	dev-python/dbus-python
	dev-python/dpkt
	dev-python/enum34
	dev-python/imaging
	dev-python/jsonrpclib
	dev-python/jsonschema
	dev-python/netifaces
	dev-python/pygobject
	dev-python/pyyaml
	dev-python/setproctitle
	dev-python/ws4py
"
# Note: dbus-python may be temporarily broken on embedded platform.

# Packages used only if X is available.
FACTORY_X_RDEPEND="
	dev-python/python-xlib
	x11-apps/xinput
	x11-apps/xrandr
	x11-misc/xdotool
"

# Packages shared by several pytests inside factory.
# TODO(itspeter): Might remove cryptohome once a conclusion
#                 comes in http://crosbug.com/p/31800.
FACTORY_TEST_RDEPEND="
	app-arch/lbzip2
	app-arch/pigz
	app-arch/xz-utils
	chromeos-base/cryptohome
	dev-python/numpy
	dev-python/pyserial
	dev-python/python-evdev
	dev-python/pyudev
	dev-python/requests
	dev-util/stressapptest
	net-ftp/pybootd
	net-misc/htpdate
	sys-apps/iproute2
	sys-apps/lshw
"

# Packages used by audio related tests
FACTORY_TEST_RDEPEND+="
	chromeos-base/audiotest
	media-sound/sox
"

# Packages used by camera related tests
FACTORY_TEST_RDEPEND+="
	media-gfx/zbar
	media-libs/opencv
"

# Packages used by removable storage test.
FACTORY_TEST_RDEPEND+="
	sys-block/parted
"

# Packages used by network related tests.
FACTORY_TEST_RDEPEND+="
	dev-python/pexpect
	net-misc/iperf:3
"

# Packages used by registration code tests.
FACTORY_TEST_RDEPEND+="
	dev-libs/protobuf-python
"

# Packages to support running autotest tests inside factory framework.
FACTORY_TEST_RDEPEND+="
	chromeos-base/autotest-client
"

# Packages for a rich set of general system commands.
FACTORY_TEST_RDEPEND+="
	sys-apps/busybox
	sys-apps/toybox
"

# Packages used by finalize.
FACTORY_TEST_RDEPEND+="
	chromeos-base/memento_softwareupdate
	sys-apps/coreboot-utils
"

# Packages used to generate QR codes.
FACTORY_TEST_RDEPEND+="
	dev-python/qrcode
"

################################################################################
# Assemble the final RDEPEND variable for portage
################################################################################
RDEPEND="${FACTORY_FRAMEWORK_RDEPEND}
	 ${FACTORY_TEST_RDEPEND}
	 X? ( ${FACTORY_X_RDEPEND} )
"
