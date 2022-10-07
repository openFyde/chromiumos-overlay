# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="2d9fa7aa4a58e237710f098492fccc28c9604a8b"
CROS_WORKON_TREE="41122a369dbd19acc78e1fe87471875655404d98"
CROS_WORKON_PROJECT="chromiumos/platform/tast-tests"
CROS_WORKON_LOCALNAME="platform/tast-tests"
CROS_WORKON_SUBTREE="android"

inherit cros-workon

DESCRIPTION="Compiled apks used by local Tast tests in the cros bundle"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/+/master/android"

LICENSE="BSD-Google GPL-3"
SLOT="0"
KEYWORDS="*"

BDEPEND="
	chromeos-base/android-sdk
	dev-util/gn
	virtual/jdk:1.8
"
RDEPEND=""
DEPEND="${RDEPEND}"
OUT=$(cros-workon_get_build_dir)

src_compile() {
	# Java 8 is deprecated and no longer setup as a system/user VM. Gentoo
	# recommends configuring manually if it is still needed. Built-in tools
	# like java-config and eselect will not show them.
	export GENTOO_VM=icedtea-bin-8
	gn gen "${OUT}" --root="${S}"/android || die "gn failed"
	ninja -C "${OUT}" || die "build failed"
}

src_install() {
	if [ ! -d "${OUT}/apks" ]; then
		ewarn "There is no apk."
		ewarn "If you want to add a helper APK, add it under tast-tests/android"
		ewarn "and modify BUILD.gn."
		return
	fi
	insinto /usr/libexec/tast/apks/local/cros
	doins "${OUT}"/apks/*
}

