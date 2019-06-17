# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5
CROS_WORKON_COMMIT="367fc705d107932356405d25e3427bba9332979a"
CROS_WORKON_TREE=("ea6e2e1b6bec83695699ef78cec2f03321d97dd7" "9033d5c4a423940ea1b1a9b5fb04a3514d04501b" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk media_perception .gn"

PLATFORM_SUBDIR="media_perception"

# Ebuild configuration partially based on following
# https://www.chromium.org/chromium-os/packages/libchrome

inherit cros-binary cros-workon udev platform user

DESCRIPTION="Media perception service"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	media-sound/adhd
	>=sys-apps/dbus-1.0
	chromeos-base/libbrillo
"
DEPEND="
	${RDEPEND}
"

LIB_VERSION=72.0.0
cros-binary_add_uri "gs://chromeos-localmirror-private/distfiles/mri_package-${LIB_VERSION}.tar.gz"

src_unpack() {
	unpack "${A}"
	platform_src_unpack
}

src_compile() {
	# Copy the library downloaded from the chromeos-localmirror-private to the
	# platform compile directory.
	cp "${WORKDIR}/librtanalytics.so" "$(cros-workon_get_build_dir)/out/Default/"
	platform_src_compile
}

src_install() {
	insinto /etc/init/
	doins "${FILESDIR}/rtanalytics.conf"
	insinto /etc/dbus-1/system.d/
	doins "${FILESDIR}/org.chromium.MediaPerception.conf"
	insinto /usr/share/policy/
	doins "${FILESDIR}/rtanalytics.policy"
	udev_dorules ${FILESDIR}/99-apex.rules
}

pkg_preinst() {
	enewgroup rtanalytics
	enewuser rtanalytics
	enewgroup apex-access
}
