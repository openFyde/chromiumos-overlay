# Copyright (C) 2011 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI=2
CROS_WORKON_PROJECT="chromiumos/platform/cros-disks"

KEYWORDS="~arm ~amd64 ~x86"

inherit toolchain-funcs cros-debug cros-workon

DESCRIPTION="Disk mounting daemon for Chromium OS."
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
IUSE="splitdebug test"

RDEPEND="
	chromeos-base/chromeos-minijail
	chromeos-base/libchromeos
	chromeos-base/metrics
	dev-cpp/gflags
	dev-libs/dbus-c++
	dev-libs/glib
	sys-apps/parted
	sys-apps/rootdev
	sys-apps/util-linux
	sys-fs/avfs
	sys-fs/ntfs3g
	sys-fs/udev
"

DEPEND="${RDEPEND}
	chromeos-base/libchrome
	chromeos-base/system_api
	dev-cpp/gmock
	test? ( dev-cpp/gtest )"

CROS_WORKON_LOCALNAME="$(basename ${CROS_WORKON_PROJECT})"

src_compile() {
	tc-export CXX CC OBJCOPY PKG_CONFIG STRIP
	cros-debug-add-NDEBUG
	emake disks || die "failed to make cros-disks"
}

src_test() {
	tc-export CXX CC OBJCOPY PKG_CONFIG STRIP
	cros-debug-add-NDEBUG
	emake tests || die "failed to make cros-disks tests"
	"${S}/build-opt/disks_testrunner" --gtest_filter='-*.RunAsRoot*' ||
		die "cros-disks tests failed"
	sudo LD_LIBRARY_PATH="${LD_LIBRARY_PATH}" \
		"${S}/build-opt/disks_testrunner" --gtest_filter='*.RunAsRoot*' ||
			die "cros-disks tests failed"
}

src_install() {
	exeinto /opt/google/cros-disks
	doexe "${S}/build-opt/disks" || die

	# Install USB device IDs file.
	insinto /opt/google/cros-disks
	doins "${S}/usb-device-info" || die

	# Install seccomp policy file.
	if [ "$ARCH" = "x86" ]; then
		newins "${S}/avfsd-seccomp-x86.policy" avfsd-seccomp.policy || die
	fi

	# Install upstart config file.
	insinto /etc/init
	doins "${S}"/cros-disks.conf || die

	# Install D-Bus config file.
	insinto /etc/dbus-1/system.d
	doins "${S}"/org.chromium.CrosDisks.conf || die
}
