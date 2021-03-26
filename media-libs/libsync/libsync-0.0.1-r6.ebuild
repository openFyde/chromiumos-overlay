# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit cros-constants

CROS_WORKON_COMMIT="f4f4387b6bf2387efbcfd1453af4892e8982faf6"
CROS_WORKON_TREE="6735ede3571072051f02df69fdf53bb239ebe6bd"
CROS_WORKON_PROJECT="aosp/platform/system/core/libsync"
CROS_WORKON_EGIT_BRANCH="master"
CROS_WORKON_REPO="${CROS_GIT_AOSP_URL}"
CROS_WORKON_LOCALNAME="../aosp/system/libsync"
CROS_WORKON_MANUAL_UPREV="1"

inherit multilib cros-workon

DESCRIPTION="Library for Android sync objects"
HOMEPAGE="https://chromium.googlesource.com/aosp/platform/system/core/libsync"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!media-libs/arc-camera3-libsync"

src_prepare() {
	cp "${FILESDIR}/Makefile" "${S}" || die "Copying Makefile"
	cp "${FILESDIR}/strlcpy.c" "${S}" || die "Copying strlcpy.c"
	cp "${FILESDIR}/libsync.pc.template" "${S}" || die "Copying libsync.pc.template"
	epatch "${FILESDIR}/0001-libsync-add-prototype-for-strlcpy.patch"
}

src_configure() {
	export GENTOO_LIBDIR=$(get_libdir)
	tc-export CC
}
