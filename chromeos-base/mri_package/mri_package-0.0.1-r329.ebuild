# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="07f829d42a43d38a24377d6f37352be040dce6b6"
CROS_WORKON_TREE=("9d87849894323414dd9afca425cb349d84a71f6b" "32b55cf8e71b8a4e3cdae51317e263da4831a8ef" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk media_perception .gn"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="media_perception"

inherit cros-workon platform udev user

LIB_VERSION=72.0.0

DESCRIPTION="Media perception service"
SRC_URI="internal? ( gs://chromeos-localmirror-private/distfiles/${PN}-${LIB_VERSION}.tar.gz )"
RESTRICT="mirror"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="internal"

RDEPEND="
	media-sound/adhd:=
	>=sys-apps/dbus-1.0:=
"
DEPEND="${RDEPEND}"

src_unpack() {
	if use internal; then
		unpack "${A}"
	fi

	platform_src_unpack
}

src_compile() {
	if use internal; then
		# Copy the library downloaded from chromeos-localmirror-private to the
		# platform compile directory.
		cp "${WORKDIR}"/librtanalytics.so "${OUT}" || die
	fi

	platform_src_compile
}

pkg_preinst() {
	enewgroup rtanalytics
	enewuser rtanalytics
	enewgroup apex-access
}

src_install() {
	insinto /etc/init/
	doins "${FILESDIR}"/rtanalytics.conf

	insinto /etc/dbus-1/system.d/
	doins "${FILESDIR}"/org.chromium.MediaPerception.conf

	insinto /usr/share/policy/
	doins "${FILESDIR}"/rtanalytics.policy

	udev_dorules "${FILESDIR}"/99-apex.rules
}
